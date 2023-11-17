module langs.sql.sqlparsers.processors.index;

import lang.sql;

@safe:

// This file : the processor for the INDEX statements.
// This class processes the INDEX statements.
class IndexProcessor : AbstractProcessor {

    protected auto getReservedType(myToken) {
        return ["expr_type" : expressionType("RESERVED"), "base_expr" : myToken];
    }

    protected auto getConstantType(myToken) {
        return ["expr_type" : expressionType("CONSTANT"), "base_expr" : myToken];
    }

    protected auto getOperatorType(myToken) {
        return ["expr_type" : expressionType("OPERATOR"), "base_expr" : myToken];
    }

    protected auto processIndexColumnList($parsed) {
        auto myProcessor = new IndexColumnListProcessor(this.options);
        return myProcessor.process($parsed);
    }

    auto process($tokens) {

        currentCategory = 'INDEX_NAME';
        $result = ["base_expr" : false, 'name' : false, "no_quotes" : false, 'index-type' : false, 'on' : false,
                        'options' : []);
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

            case 'USING':
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = 'TYPE_OPTION';
                    continue 2;
                }
                if ($prevCategory == 'TYPE_DEF') {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = 'INDEX_TYPE';
                    continue 2;
                }
                // else ?
                break;

            case 'KEY_BLOCK_SIZE':
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = 'INDEX_OPTION';
                    continue 2;
                }
                // else ?
                break;

            case 'WITH':
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = 'INDEX_PARSER';
                    continue 2;
                }
                // else ?
                break;

            case 'PARSER':
                if (currentCategory == 'INDEX_PARSER') {
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case 'COMMENT':
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = 'INDEX_COMMENT';
                    continue 2;
                }
                // else ?
                break;

            case 'ALGORITHM':
            case 'LOCK':
                if ($prevCategory == "CREATE_DEF") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = upperToken . "_OPTION";
                    continue 2;
                }
                // else ?
                break;

            case '=':
            // the optional operator
                if (substr(currentCategory, -7, 7) == "_OPTION") {
                    myExpression[] = this.getOperatorType(strippedToken);
                    continue 2; // don't change the category
                }
                // else ?
                break;

            case 'ON':
                if ($prevCategory == "CREATE_DEF" || $prevCategory == 'TYPE_DEF') {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = 'TABLE_DEF';
                    continue 2;
                }
                // else ?
                break;

            default:
                switch (currentCategory) {

                case 'COLUMN_DEF':
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                        $result["on"]["base_expr"] ~= baseExpression;
                        $result["on"]["sub_tree"] = ["expr_type" : expressionType("COLUMN_LIST"),
                                                          "base_expr" : strippedToken, "sub_tree" : $cols];
                    }

                    myExpression = [];
                    baseExpression = "";
                    currentCategory = "CREATE_DEF";
                    break;

                case 'TABLE_DEF':
                // the table name
                    myExpression[] = this.getConstantType(strippedToken);
                    // TODO: the base_expr should contain the column-def too
                    $result["on"] = ["expr_type" : expressionType("TABLE"), "base_expr" : baseExpression,
                                          'name' : strippedToken, "no_quotes" : this.revokeQuotation(strippedToken),
                                          "sub_tree" : false];
                    myExpression = [];
                    baseExpression = "";
                    currentCategory = 'COLUMN_DEF';
                    continue 3;

                case 'INDEX_NAME':
                    $result["base_expr"] = $result["name"] = strippedToken;
                    $result["no_quotes"] = this.revokeQuotation(strippedToken);

                    myExpression = [];
                    baseExpression = "";
                    currentCategory = 'TYPE_DEF';
                    break;

                case 'INDEX_PARSER':
                // the parser name
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("INDEX_PARSER"),
                                                 "base_expr" : baseExpression.strip, "sub_tree" : myExpression];
                    myExpression = [];
                    baseExpression = "";
                    currentCategory = "CREATE_DEF";

                    break;

                case 'INDEX_COMMENT':
                // the index comment
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("COMMENT"),
                                                 "base_expr" : baseExpression.strip, "sub_tree" : myExpression];
                    myExpression = [];
                    baseExpression = "";
                    currentCategory = "CREATE_DEF";

                    break;

                case 'INDEX_OPTION':
                // the key_block_size
                    myExpression[] = this.getConstantType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("INDEX_SIZE"),
                                                 "base_expr" : baseExpression.strip, 'size' : upperToken,
                                                 "sub_tree" : myExpression];
                    myExpression = [];
                    baseExpression = "";
                    currentCategory = "CREATE_DEF";

                    break;

                case 'INDEX_TYPE':
                case 'TYPE_OPTION':
                // BTREE or HASH
                    myExpression[] = this.getReservedType(strippedToken);
                    if (currentCategory == 'INDEX_TYPE') {
                        $result["index-type"] = ["expr_type" : expressionType("INDEX_TYPE"),
                                                      "base_expr" : baseExpression.strip, 'using' : upperToken,
                                                      "sub_tree" : myExpression];
                    } else {
                        $result["options"][] = ["expr_type" : expressionType("INDEX_TYPE"),
                                                     "base_expr" : baseExpression.strip, 'using' : upperToken,
                                                     "sub_tree" : myExpression];
                    }

                    myExpression = [];
                    baseExpression = "";
                    currentCategory = "CREATE_DEF";
                    break;

                case 'LOCK_OPTION':
                // DEFAULT|NONE|SHARED|EXCLUSIVE
                    myExpression[] = this.getReservedType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("INDEX_LOCK"),
                                                 "base_expr" : baseExpression.strip, 'lock' : upperToken,
                                                 "sub_tree" : myExpression];

                    myExpression = [];
                    baseExpression = "";
                    currentCategory = "CREATE_DEF";
                    break;

                case 'ALGORITHM_OPTION':
                // DEFAULT|INPLACE|COPY
                    myExpression[] = this.getReservedType(strippedToken);
                    $result["options"][] = ["expr_type" : expressionType("INDEX_ALGORITHM"),
                                                 "base_expr" : baseExpression.strip, 'algorithm' : upperToken,
                                                 "sub_tree" : myExpression];

                    myExpression = [];
                    baseExpression = "";
                    currentCategory = "CREATE_DEF";

                    break;

                default:
                    break;
                }

                break;
            }

            $prevCategory = currentCategory;
            currentCategory = "";
        }

        if ($result["options"] == []) {
            $result["options"] = false;
        }
        return $result;
    }
}
