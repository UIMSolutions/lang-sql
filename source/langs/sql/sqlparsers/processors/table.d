module langs.sql.sqlparsers.processors.table;

import lang.sql;

@safe:

// This class processes the TABLE statements.
class TableProcessor : AbstractProcessor {

    protected auto getReservedType(myToken) {
        return ["expr_type" : expressionType("RESERVED"), "base_expr" : $token];
    }

    protected auto getConstantType($token) {
        return ["expr_type" : expressionType("CONSTANT"), "base_expr" : $token];
    }

    protected auto getOperatorType($token) {
        return ["expr_type" : expressionType("OPERATOR"), "base_expr" : $token];
    }

    protected auto processPartitionOptions($tokens) {
        auto myProcessor = new PartitionOptionsProcessor(this.options);
        return myProcessor.process($tokens);
    }

    protected auto processCreateDefinition($tokens) {
        auto myProcessor = new CreateDefinitionProcessor(this.options);
        return myProcessor.process($tokens);
    }

    protected auto clear(&myExpression, &baseExpression, &$category) {
        myExpression = [];
        baseExpression = "";
        $category = "CREATE_DEF";
    }

    auto process($tokens) {

        currentCategory = "TABLE_NAME";
        $result = ["base_expr" : false, "name" : false, "no_quotes" : false, "create-def" : false,
                        "options" : [], "like" : false, "select-option" : false];
        myExpression = [];
        baseExpression = "";
        $skip = 0;

        foreach ($tokenKey : myToken; $tokens) {
            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case ",":
            // it is possible to separate the table options with comma!
                if ($prevCategory == "CREATE_DEF") {
                    $last = array_pop($result["options"]);
                    $last["delim"] = ",";
                    $result["options"][] = $last;
                    baseExpression = "";
                }
                continue 2;

            case "UNION":
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = "UNION";
                    continue 2;
                }
                break;

            case "LIKE":
            // like without parenthesis
                if ($prevCategory == "TABLE_NAME") {
                    currentCategory = upperToken;
                    continue 2;
                }
                break;

            case "=":
            // the optional operator
                if ($prevCategory == "TABLE_OPTION") {
                    myExpression[] = this.getOperatorType(strippedToken);
                    continue 2; // don"t change the category
                }
                break;

            case "CHARACTER":
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = "TABLE_OPTION";
                }
                if ($prevCategory == "TABLE_OPTION") {
                    // add it to the previous DEFAULT
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case "SET":
            case "CHARSET":
                if ($prevCategory == "TABLE_OPTION") {
                    // add it to a previous CHARACTER
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = "CHARSET";
                    continue 2;
                }
                break;

            case "COLLATE":
                if ($prevCategory == "TABLE_OPTION" || $prevCategory == "CREATE_DEF") {
                    // add it to the previous DEFAULT
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = "COLLATE";
                    continue 2;
                }
                break;

            case "DIRECTORY":
                if (currentCategory == "INDEX_DIRECTORY" || currentCategory == "DATA_DIRECTORY") {
                    // after INDEX or DATA
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case "INDEX":
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = "INDEX_DIRECTORY";
                    continue 2;
                }
                break;

            case "DATA":
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = "DATA_DIRECTORY";
                    continue 2;
                }
                break;

            case "INSERT_METHOD":
            case "DELAY_KEY_WRITE":
            case "ROW_FORMAT":
            case "PASSWORD":
            case "MAX_ROWS":
            case "MIN_ROWS":
            case "PACK_KEYS":
            case "CHECKSUM":
            case "COMMENT":
            case "CONNECTION":
            case "AUTO_INCREMENT":
            case "AVG_ROW_LENGTH":
            case "ENGINE":
            case "TYPE":
            case "STATS_AUTO_RECALC":
            case "STATS_PERSISTENT":
            case "KEY_BLOCK_SIZE":
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = $prevCategory = "TABLE_OPTION";
                    continue 2;
                }
                break;

            case "DYNAMIC":
            case "FIXED":
            case "COMPRESSED":
            case "REDUNDANT":
            case "COMPACT":
            case "NO":
            case "FIRST":
            case "LAST":
            case "DEFAULT":
                if ($prevCategory == "CREATE_DEF") {
                    // DEFAULT before CHARACTER SET and COLLATE
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = "TABLE_OPTION";
                }
                if ($prevCategory == "TABLE_OPTION") {
                    // all assignments with the keywords
                    myExpression[] = this.getReservedType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("EXPRESSION"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                }
                break;

            case "IGNORE":
            case "REPLACE":
                myExpression[] = this.getReservedType(strippedToken);
                $result["select-option"] = ["base_expr" : baseExpression.strip, "duplicates" : strippedToken, "as" : false,
                                                 "sub_tree" : myExpression];
                continue 2;

            case "AS":
                myExpression[] = this.getReservedType(strippedToken);
                if (!isset($result["select-option"]["duplicates"])) {
                    $result["select-option"]["duplicates"] = false;
                }
                $result["select-option"]["as"] = true;
                $result["select-option"].baseExpression = baseExpression.strip;
                $result["select-option"]["sub_tree"] = myExpression;
                continue 2;

            case "PARTITION":
                if ($prevCategory == "CREATE_DEF") {
                    $part = this.processPartitionOptions(array_slice($tokens, $tokenKey - 1, null, true));
                    $skip = $part["last-parsed"] - $tokenKey;
                    $result["partition-options"] = $part["partition-options"];
                    continue 2;
                }
                // else
                break;

            default:
                switch (currentCategory) {

                case "CHARSET":
                // the charset name
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("CHARSET"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                case "COLLATE":
                // the collate name
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("COLLATE"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                case "DATA_DIRECTORY":
                // we have the directory name
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("DIRECTORY"), "kind" : "DATA",
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, $prevCategory);
                    continue 3;

                case "INDEX_DIRECTORY":
                // we have the directory name
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = createExpression("DIRECTORY"), "kind" : "INDEX",
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, $prevCategory);
                    continue 3;

                case "TABLE_NAME":
                    $result.baseExpression = $result["name"] = strippedToken;
                    $result["no_quotes"] = this.revokeQuotation(strippedToken);
                    this.clear(myExpression, baseExpression, $prevCategory);
                    break;

                case "LIKE":
                    $result["like"] = createExpression("TABLE"), "table" : strippedToken,
                                            "base_expr" : strippedToken, "no_quotes" : this.revokeQuotation(strippedToken));
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                case "":
                // after table name
                    if ($prevCategory == "TABLE_NAME" && upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $unparsed = this.splitSQLIntoTokens(this.removeParenthesisFromStart(strippedToken));
                        $coldef = this.processCreateDefinition($unparsed);
                        $result["create-def"] = ["expr_type" : expressionType("BRACKET_EXPRESSION"),
                                                      "base_expr" : baseExpression, "sub_tree" : $coldef["create-def"]);
                        myExpression = [];
                        baseExpression = "";
                        currentCategory = "CREATE_DEF";
                    }
                    break;

                case "UNION":
                // TODO: this token starts and ends with parenthesis
                // and contains a list of table names (comma-separated)
                // split the token and add the list as subtree
                // we must change the DefaultProcessor

                    $unparsed = this.splitSQLIntoTokens(this.removeParenthesisFromStart(strippedToken));
                    myExpression[] = ["expr_type" : expressionType("BRACKET_EXPRESSION"), "base_expr" : strippedToken,
                                    "sub_tree" : "***TODO***");
                    $result["options"][] = ["expr_type" : expressionType(UNION, "base_expr" : baseExpression.strip,
                                                 "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;

                default:
                // strings and numeric constants
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("EXPRESSION"),
                                                 "base_expr" : baseExpression.strip, "delim" : " ", "sub_tree" : myExpression];
                    this.clear(myExpression, baseExpression, currentCategory);
                    break;
                }
                break;
            }

            $prevCategory = currentCategory;
            currentCategory = "";
        }

        if ($result["like"] == false) {
            unset($result["like"]);
        }
        if ($result["select-option"].isEmpty) {
            unset($result["select-option"]);
        }
        if ($result["options"] == []) {
            $result["options"] = false;
        }

        return $result;
    }
}