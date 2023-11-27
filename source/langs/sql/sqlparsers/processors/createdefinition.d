module langs.sql.sqlparsers.processors.createdefinition;

import lang.sql;

@safe:

/**
 * This file : the processor for the create definition within the TABLE statements.
 * This class processes the create definition of the TABLE statements.
 */
class CreateDefinitionProcessor : AbstractProcessor {

    protected auto processExpressionList($parsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto processIndexColumnList($parsed) {
        auto myProcessor = new IndexColumnListProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto processColumnDefinition($parsed) {
        auto myProcessor = new ColumnDefinitionProcessor(this.options);
        return myProcessor.process($parsed);
    }

    protected auto processReferenceDefinition($parsed) {
        auto myProcessor = new ReferenceDefinitionProcessor(this.options);
        return myProcessorr.process($parsed);
    }

    protected auto correctExpressionType(&myExpression) {
        $type .isExpressionType(EXPRESSION;
        if (!myExpression.isSet(0) || !myExpression[0].isSet("expr_type")) {
            return $type;
        }

        // replace the constraint type with a more descriptive one
        switch (myExpression[0]["expr_type"]) {

        case expressionType("CONSTRAINT"):
            $type = myExpression[1]["expr_type"];
            myExpression[1]["expr_type"] .isExpressionType(RESERVED;
            break;

        case expressionType("COLREF"):
            $type .isExpressionType(COLDEF;
            break;

        default:
            $type = myExpression[0]["expr_type"];
            myExpression[0]["expr_type"] .isExpressionType("RESERVED");
            break;

        }
        return $type;
    }

    auto process($tokens) {

        string baseExpression = "";
        string prevCategory = "";
        string currentCategory = "";
        myExpression = [];
        $result = [];
        $skip = 0;

        foreach (myKey, myToken; $tokens) {

            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if ($skip != 0) {
                $skip--;
                continue;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;

            switch (upperToken) {

            case "CONSTRAINT":
                myExpression[] = ["expr_type" : expressionType("CONSTRAINT"), "base_expr" : strippedToken, "sub_tree" : false];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "LIKE":
                myExpression[] = ["expr_type" : expressionType("LIKE"), "base_expr": strippedToken];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "FOREIGN":
                if (prevCategory.isEmpty || prevCategory == "CONSTRAINT") {
                    myExpression[] = ["expr_type" : expressionType("FOREIGN_KEY"), "base_expr": strippedToken];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "PRIMARY":
                if (prevCategory.isEmpty || prevCategory == "CONSTRAINT") {
                    // next one is KEY
                    myExpression[] = ["expr_type" : expressionType("PRIMARY_KEY"), "base_expr": strippedToken];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "UNIQUE":
                if (prevCategory.isEmpty || prevCategory == "CONSTRAINT" || prevCategory == "INDEX_COL_LIST") {
                    // next one is KEY
                    myExpression[] = ["expr_type" : expressionType("UNIQUE_IDX"), "base_expr": strippedToken];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "KEY":
            // the next one is an index name
                if (currentCategory == "PRIMARY" || currentCategory == "FOREIGN" || currentCategory == "UNIQUE") {
                    myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    continue 2;
                }
                myExpression[] = ["expr_type" : expressionType("INDEX"), "base_expr": strippedToken];
                currentCategory = upperToken;
                continue 2;

            case "CHECK":
                myExpression[] = ["expr_type" : expressionType("CHECK"), "base_expr": strippedToken];
                currentCategory = upperToken;
                continue 2;

            case "INDEX":
                if (currentCategory == "UNIQUE" || currentCategory == "FULLTEXT" || currentCategory == "SPATIAL") {
                    myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    continue 2;
                }
                myExpression[] = ["expr_type" : expressionType("INDEX"), "base_expr": strippedToken];
                currentCategory = upperToken;
                continue 2;

            case "FULLTEXT":
                myExpression[] = ["expr_type" : expressionType("FULLTEXT_IDX"), "base_expr": strippedToken];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "SPATIAL":
                myExpression[] = ["expr_type" : expressionType("SPATIAL_IDX"), "base_expr": strippedToken];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "WITH":
            // starts an index option
                if (currentCategory == "INDEX_COL_LIST") {
                    $option = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression[] = ["expr_type" : expressionType("INDEX_PARSER"),
                                    "base_expr" : substr(baseExpression, 0, -myToken.length),
                                    "sub_tree" : [$option)];
                    baseExpression = myToken;
                    currentCategory = "INDEX_PARSER";
                    continue 2;
                }
                break;

            case "KEY_BLOCK_SIZE":
            // starts an index option
                if (currentCategory == "INDEX_COL_LIST") {
                    $option = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression[] = ["expr_type" : expressionType("INDEX_SIZE"),
                                    "base_expr" : substr(baseExpression, 0, -myToken.length),
                                    "sub_tree" : [$option)];
                    baseExpression = myToken;
                    currentCategory = "INDEX_SIZE";
                    continue 2;
                }
                break;

            case "USING":
            // starts an index option
                if (currentCategory == "INDEX_COL_LIST" || currentCategory == "PRIMARY") {
                    $option = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression[] = ["base_expr" : substr(baseExpression, 0, -myToken.length), "trim" : strippedToken,
                                    "category" : currentCategory, "sub_tree" : [$option));
                    baseExpression = myToken;
                    currentCategory = "INDEX_TYPE";
                    continue 2;
                }
                // else ?
                break;

            case "REFERENCES":
                if (currentCategory == "INDEX_COL_LIST" && prevCategory == "FOREIGN") {
                    $refs = this.processReferenceDefinition(array_slice($tokens, myKey - 1, null, true));
                    $skip = $refs["till"] - myKey;
                    unset($refs["till"]);
                    myExpression[] = $refs;
                    currentCategory = upperToken;
                }
                // else ?
                break;

            case "BTREE":
            case "HASH":
                if (currentCategory == "INDEX_TYPE") {
                    $last = array_pop(myExpression);
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression[] = ["expr_type" : expressionType("INDEX_TYPE"), "base_expr" : baseExpression,
                                    "sub_tree" : $last["sub_tree"]);
                    baseExpression = $last.baseExpression . baseExpression;

                    // FIXME: it could be wrong for index_type within index_option
                    currentCategory = $last["category"];
                    continue 2;
                }
                // else ?
                break;

            case "=":
                if (currentCategory == "INDEX_SIZE") {
                    // the optional character between KEY_BLOCK_SIZE and the numeric constant
                    $last = array_pop(myExpression);
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression[] = $last;
                    continue 2;
                }
                break;

            case "PARSER":
                if (currentCategory == "INDEX_PARSER") {
                    $last = array_pop(myExpression);
                    $last["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression[] = $last;
                    continue 2;
                }
                // else ?
                break;

            case ",":
            // this starts the next definition
                $type = this.correctExpressionType(myExpression);
                $result["create-def"][] = ["expr_type" : $type,
                                                "base_expr" : substr(baseExpression, 0, -myToken.length).strip,
                                                "sub_tree" : myExpression];
                baseExpression = "";
                myExpression = [];
                break;

            default:
                switch (currentCategory) {

                case "LIKE":
                // this is the tablename after LIKE
                    myExpression[] = ["expr_type" : expressionType("TABLE"), "table" : strippedToken, "base_expr" : strippedToken,
                                    "no_quotes" : this.revokeQuotation(strippedToken)];
                    break;

                case "PRIMARY":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        // the column list
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                        myExpression[] = ["expr_type" : expressionType("COLUMN_LIST"), "base_expr" : strippedToken,
                                        "sub_tree" : $cols);
                        prevCategory = currentCategory;
                        currentCategory = "INDEX_COL_LIST";
                        continue 3;
                    }
                    // else?
                    break;

                case "FOREIGN":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                        myExpression[] = ["expr_type" : expressionType("COLUMN_LIST"), "base_expr" : strippedToken,
                                        "sub_tree" : $cols);
                        prevCategory = currentCategory;
                        currentCategory = "INDEX_COL_LIST";
                        continue 3;
                    }
                    // index name
                    myExpression[] = ["expr_type" : expressionType("CONSTANT"), "base_expr": strippedToken];
                    continue 3;

                case "KEY":
                case "UNIQUE":
                case "INDEX":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $cols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                        myExpression[] = ["expr_type" : expressionType("COLUMN_LIST"), "base_expr" : strippedToken,
                                        "sub_tree" : $cols];
                        prevCategory = currentCategory;
                        currentCategory = "INDEX_COL_LIST";
                        continue 3;
                    }
                    // index name
                    myExpression[] = ["expr_type" : expressionType("CONSTANT"), "base_expr": strippedToken];
                    continue 3;

                case "CONSTRAINT":
                // constraint name
                    $last = array_pop(myExpression);
                    $last.baseExpression = baseExpression;
                    $last["sub_tree"] = ["expr_type" : expressionType("CONSTANT"), "base_expr": strippedToken];
                    myExpression[] = $last;
                    continue 3;

                case "INDEX_PARSER":
                // index parser name
                    $last = array_pop(myExpression);
                    $last["sub_tree"][] = ["expr_type" : expressionType("CONSTANT"), "base_expr": strippedToken];
                    myExpression[] = ["expr_type" : expressionType("INDEX_PARSER"), "base_expr" : baseExpression,
                                    "sub_tree" : $last["sub_tree"]);
                    baseExpression = $last.baseExpression . baseExpression;
                    currentCategory = "INDEX_COL_LIST";
                    continue 3;

                case "INDEX_SIZE":
                // index key block size numeric constant
                    $last = array_pop(myExpression);
                    $last["sub_tree"][] = ["expr_type" : expressionType("CONSTANT"), "base_expr": strippedToken];
                    myExpression[] = ["expr_type" : expressionType("INDEX_SIZE"), "base_expr" : baseExpression,
                                    "sub_tree" : $last["sub_tree"]);
                    baseExpression = $last.baseExpression . baseExpression;
                    currentCategory = "INDEX_COL_LIST";
                    continue 3;

                case "CHECK":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        $parsed = this.splitSQLIntoTokens(this.removeParenthesisFromStart(strippedToken));
                        $parsed = this.processExpressionList($parsed);
                        myExpression[] = ["expr_type" : expressionType("BRACKET_EXPRESSION"), "base_expr" : strippedToken,
                                        "sub_tree" : $parsed);
                    }
                    // else?
                    break;

                case "":
                // if the currCategory is empty, we have an unknown token,
                // which is a column reference
                    myExpression[] = ["expr_type" : expressionType("COLREF"), "base_expr" : strippedToken,
                                    "no_quotes" : this.revokeQuotation(strippedToken)];
                    currentCategory = "COLUMN_NAME";
                    continue 3;

                case "COLUMN_NAME":
                // the column-definition
                // it stops on a comma or on a parenthesis
                    $parsed = this.processColumnDefinition(array_slice($tokens, myKey, null, true));
                    $skip = $parsed["till"] - myKey;
                    unset($parsed["till"]);
                    myExpression[] = $parsed;
                    currentCategory = "";
                    break;

                default:
                // ?
                    break;
                }
                break;
            }
            prevCategory = currentCategory;
            currentCategory = "";
        }

        $type = this.correctExpressionType(myExpression);
        $result["create-def"][] = ["expr_type" : $type, "base_expr" : baseExpression.strip, "sub_tree" : myExpression];
        return $result;
    }
}
