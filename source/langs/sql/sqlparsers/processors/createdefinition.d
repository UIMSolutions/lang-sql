module langs.sql.sqlparsers.processors.createdefinition;

import lang.sql;

@safe:

// This class processes the create definition of the TABLE statements.
class CreateDefinitionProcessor : Processor {

    protected Json processExpressionList(myparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process(myparsed);
    }

    protected Json processIndexColumnList(myparsed) {
        auto myProcessor = new IndexColumnListProcessor(this.options);
        return myProcessor.process(myparsed);
    }

    protected Json processColumnDefinition(myparsed) {
        auto myProcessor = new ColumnDefinitionProcessor(this.options);
        return myProcessor.process(myparsed);
    }

    protected Json processReferenceDefinition(myparsed) {
        auto myProcessor = new ReferenceDefinitionProcessor(this.options);
        return myProcessorr.process(myparsed);
    }

    protected auto correctExpressionType(&myExpression) {
        mytype .isExpressionType(EXPRESSION;
        if (!myExpression.isSet(0) || !myExpression[0].isSet("expr_type")) {
            return mytype;
        }

        // replace the constraint type with a more descriptive one
        switch (myExpression[0]["expr_type"]) {

        case expressionType("CONSTRAINT"):
            mytype = myExpression[1]["expr_type"];
           myExpression[1]["expr_type"] .isExpressionType(RESERVED;
            break;

        case expressionType("COLREF"):
            mytype .isExpressionType(COLDEF;
            break;

        default:
            mytype = myExpression[0]["expr_type"];
           myExpression[0]["expr_type"] .isExpressionType("RESERVED");
            break;

        }
        return mytype;
    }

    Json process(mytokens) {

        string baseExpression = "";
        string prevCategory = "";
        string currentCategory = "";
       myExpression = [];
        myresult = [];
        myskip = 0;

        foreach (myKey, myToken; mytokens) {

            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if (myskip != 0) {
                myskip--;
                continue;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;

            switch (upperToken) {

            case "CONSTRAINT":
               myExpression ~= createExpression("CONSTRAINT"), "base_expr" : strippedToken, "sub_tree" : false];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "LIKE":
               myExpression ~= createExpression("LIKE"), "base_expr": strippedToken];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "FOREIGN":
                if (prevCategory.isEmpty || prevCategory == "CONSTRAINT") {
                   myExpression ~= createExpression("FOREIGN_KEY"), "base_expr": strippedToken];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "PRIMARY":
                if (prevCategory.isEmpty || prevCategory == "CONSTRAINT") {
                    // next one is KEY
                   myExpression ~= createExpression("PRIMARY_KEY"), "base_expr": strippedToken];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "UNIQUE":
                if (prevCategory.isEmpty || prevCategory == "CONSTRAINT" || prevCategory == "INDEX_COL_LIST") {
                    // next one is KEY
                   myExpression ~= createExpression("UNIQUE_IDX"), "base_expr": strippedToken];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "KEY":
            // the next one is an index name
                if (currentCategory == "PRIMARY" || currentCategory == "FOREIGN" || currentCategory == "UNIQUE") {
                   myExpression ~= createExpression("RESERVED", "base_expr": strippedToken];
                    continue 2;
                }
               myExpression ~= createExpression("INDEX"), "base_expr": strippedToken];
                currentCategory = upperToken;
                continue 2;

            case "CHECK":
               myExpression ~= createExpression("CHECK"), "base_expr": strippedToken];
                currentCategory = upperToken;
                continue 2;

            case "INDEX":
                if (currentCategory == "UNIQUE" || currentCategory == "FULLTEXT" || currentCategory == "SPATIAL") {
                   myExpression ~= createExpression("RESERVED"), "base_expr": strippedToken];
                    continue 2;
                }
               myExpression ~= createExpression("INDEX"), "base_expr": strippedToken];
                currentCategory = upperToken;
                continue 2;

            case "FULLTEXT":
               myExpression ~= createExpression("FULLTEXT_IDX"), "base_expr": strippedToken];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "SPATIAL":
               myExpression ~= createExpression("SPATIAL_IDX"), "base_expr": strippedToken];
                currentCategory = prevCategory = upperToken;
                continue 2;

            case "WITH":
            // starts an index option
                if (currentCategory == "INDEX_COL_LIST") {
                    myoption = createExpression("RESERVED"), "base_expr": strippedToken];
                   myExpression ~= createExpression("INDEX_PARSER"),
                                    "base_expr" : substr(baseExpression, 0, -myToken.length),
                                    "sub_tree" : [myoption)];
                    baseExpression = myToken;
                    currentCategory = "INDEX_PARSER";
                    continue 2;
                }
                break;

            case "KEY_BLOCK_SIZE":
            // starts an index option
                if (currentCategory == "INDEX_COL_LIST") {
                    myoption = createExpression("RESERVED"), "base_expr": strippedToken];
                   myExpression ~= createExpression("INDEX_SIZE"),
                                    "base_expr" : substr(baseExpression, 0, -myToken.length),
                                    "sub_tree" : [myoption)];
                    baseExpression = myToken;
                    currentCategory = "INDEX_SIZE";
                    continue 2;
                }
                break;

            case "USING":
            // starts an index option
                if (currentCategory == "INDEX_COL_LIST" || currentCategory == "PRIMARY") {
                    myoption = createExpression("RESERVED"), "base_expr": strippedToken];
                   myExpression ~= ["base_expr" : substr(baseExpression, 0, -myToken.length), "trim" : strippedToken,
                                    "category" : currentCategory, "sub_tree" : [myoption));
                    baseExpression = myToken;
                    currentCategory = "INDEX_TYPE";
                    continue 2;
                }
                // else ?
                break;

            case "REFERENCES":
                if (currentCategory == "INDEX_COL_LIST" && prevCategory == "FOREIGN") {
                    myrefs = this.processReferenceDefinition(array_slice(mytokens, myKey - 1, null, true));
                    myskip = myrefs["till"] - myKey;
                    unset(myrefs["till"]);
                   myExpression ~= myrefs;
                    currentCategory = upperToken;
                }
                // else ?
                break;

            case "BTREE":
            case "HASH":
                if (currentCategory == "INDEX_TYPE") {
                    mylast = array_pop(myExpression);
                    mylast["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                   myExpression ~= createExpression("INDEX_TYPE"), "base_expr" : baseExpression,
                                    "sub_tree" : mylast["sub_tree"]);
                    baseExpression = mylast.baseExpression . baseExpression;

                    // FIXME: it could be wrong for index_type within index_option
                    currentCategory = mylast["category"];
                    continue 2;
                }
                // else ?
                break;

            case "=":
                if (currentCategory == "INDEX_SIZE") {
                    // the optional character between KEY_BLOCK_SIZE and the numeric constant
                    mylast = array_pop(myExpression);
                    mylast["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                   myExpression ~= mylast;
                    continue 2;
                }
                break;

            case "PARSER":
                if (currentCategory == "INDEX_PARSER") {
                    mylast = array_pop(myExpression);
                    mylast["sub_tree"] ~= createExpression("RESERVED"), "base_expr": strippedToken];
                   myExpression ~= mylast;
                    continue 2;
                }
                // else ?
                break;

            case ",":
            // this starts the next definition
                mytype = this.correctExpressionType(myExpression);
                myresult["create-def"] ~= ["expr_type" : mytype,
                                                "base_expr" : substr(baseExpression, 0, -myToken.length).strip,
                                                "sub_tree" : myExpression];
                baseExpression = "";
               myExpression = [];
                break;

            default:
                switch (currentCategory) {

                case "LIKE":
                // this is the tablename after LIKE
                   myExpression ~= createExpression("TABLE"), "table" : strippedToken, "base_expr" : strippedToken,
                                    "no_quotes" : this.revokeQuotation(strippedToken)];
                    break;

                case "PRIMARY":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        // the column list
                        mycols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                       myExpression ~= createExpression("COLUMN_LIST"), "base_expr" : strippedToken,
                                        "sub_tree" : mycols);
                        prevCategory = currentCategory;
                        currentCategory = "INDEX_COL_LIST";
                        continue 3;
                    }
                    // else?
                    break;

                case "FOREIGN":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        mycols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                       myExpression ~= createExpression("COLUMN_LIST"), "base_expr" : strippedToken,
                                        "sub_tree" : mycols);
                        prevCategory = currentCategory;
                        currentCategory = "INDEX_COL_LIST";
                        continue 3;
                    }
                    // index name
                   myExpression ~= createExpression("CONSTANT"), "base_expr": strippedToken];
                    continue 3;

                case "KEY":
                case "UNIQUE":
                case "INDEX":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        mycols = this.processIndexColumnList(this.removeParenthesisFromStart(strippedToken));
                       myExpression ~= createExpression("COLUMN_LIST"), "base_expr" : strippedToken,
                                        "sub_tree" : mycols];
                        prevCategory = currentCategory;
                        currentCategory = "INDEX_COL_LIST";
                        continue 3;
                    }
                    // index name
                   myExpression ~= createExpression("CONSTANT"), "base_expr": strippedToken];
                    continue 3;

                case "CONSTRAINT":
                // constraint name
                    mylast = array_pop(myExpression);
                    mylast["base_expr"] = baseExpression;
                    mylast["sub_tree"] = createExpression("CONSTANT"), "base_expr": strippedToken];
                   myExpression ~= mylast;
                    continue 3;

                case "INDEX_PARSER":
                // index parser name
                    mylast = array_pop(myExpression);
                    mylast["sub_tree"] ~= createExpression("CONSTANT"), "base_expr": strippedToken];
                   myExpression ~= createExpression("INDEX_PARSER"), "base_expr" : baseExpression,
                                    "sub_tree" : mylast["sub_tree"]);
                    baseExpression = mylast.baseExpression . baseExpression;
                    currentCategory = "INDEX_COL_LIST";
                    continue 3;

                case "INDEX_SIZE":
                // index key block size numeric constant
                    mylast = array_pop(myExpression);
                    mylast["sub_tree"] ~= createExpression("CONSTANT"), "base_expr": strippedToken];
                   myExpression ~= createExpression("INDEX_SIZE"), "base_expr" : baseExpression,
                                    "sub_tree" : mylast["sub_tree"]);
                    baseExpression = mylast.baseExpression . baseExpression;
                    currentCategory = "INDEX_COL_LIST";
                    continue 3;

                case "CHECK":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        myparsed = this.splitSQLIntoTokens(this.removeParenthesisFromStart(strippedToken));
                        myparsed = this.processExpressionList(myparsed);
                       myExpression ~= createExpression("BRACKET_EXPRESSION"), "base_expr" : strippedToken,
                                        "sub_tree" : myparsed);
                    }
                    // else?
                    break;

                case "":
                // if the currCategory is empty, we have an unknown token,
                // which is a column reference
                   myExpression ~= createExpression("COLREF"), "base_expr" : strippedToken,
                                    "no_quotes" : this.revokeQuotation(strippedToken)];
                    currentCategory = "COLUMN_NAME";
                    continue 3;

                case "COLUMN_NAME":
                // the column-definition
                // it stops on a comma or on a parenthesis
                    myparsed = this.processColumnDefinition(array_slice(mytokens, myKey, null, true));
                    myskip = myparsed["till"] - myKey;
                    unset(myparsed["till"]);
                   myExpression ~= myparsed;
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

        mytype = this.correctExpressionType(myExpression);
        myresult["create-def"] ~= ["expr_type" : mytype, "base_expr" : baseExpression.strip, "sub_tree" : myExpression];
        return myresult;
    }
}
