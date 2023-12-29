module langs.sql.sqlparsers.processors.partitiondefinitionprocessor;

import langs.sql;

@safe:

// This class processes the PARTITION statements within CREATE TABLE.
class PartitionDefinitionProcessor : Processor {

    protected Json processExpressionList(myunparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
       myExpression = this.removeParenthesisFromStart(myunparsed);
        auto myTokens = this.splitSQLIntoTokens(myExpression);
        return myProcessor.process(myTokens);
    }

    protected Json processSubpartitionDefinition(myunparsed) {
        auto myProcessor = new SubpartitionDefinitionProcessor(this.options);
       myExpression = this.removeParenthesisFromStart(myunparsed);
        auto myTokens = this.splitSQLIntoTokens(myExpression);
        return myProcessor.process(myTokens);
    }

    protected auto getReservedType(mytoken) {
        return createExpression("RESERVED", mytoken);
    }

    protected auto getConstantType(mytoken) {
        return createExpression("CONSTANT", mytoken);
    }

    protected auto getOperatorType(mytoken) {
        return createExpression("OPERATOR", mytoken);
    }

    protected auto getBracketExpressionType(mytoken) {
        auto newExpression =  createExpression("BRACKET_EXPRESSION", mytoken);
        newExpression["sub_tree"] = Json.emptyArray;
    }

    Json process(strig[] tokens) {
auto myresult = [];
        string myPreviousCategory = "";
        string myCurrentCategory = "";
        myparsed = [];
       myExpression = [];
        string baseExpression = "";
        myskip = 0;

        foreach (mytokenKey, mytoken; mytokens) {
            auto strippedToken = mytoken.strip;
            baseExpression ~= mytoken;

            if (myskip > 0) {
                myskip--;
                continue;
            }

            if (myskip < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case "PARTITION":
                if (myCurrentCategory.isEmpty) {
                   myExpression ~= this.getReservedType(strippedToken);
                    myparsed = createExpression("PARTITION_DEF", baseExpression.strip);
                                    "sub_tree" : false];
                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "VALUES":
                if (myPreviousCategory == "PARTITION") {
                   auto myExpression = createExpression("PARTITION_VALUES", "");
                  myExpression["sub_tree"] = Json.emptyArray;
                  myExpression["storage"] = substr(baseExpression, 0, - mytoken.length);
                    myparsed["sub_tree"] ~= myExpression;

                    baseExpression = mytoken;
                   myExpression = [this.getReservedType(strippedToken));

                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "LESS":
                if (myCurrentCategory == "VALUES") {
                   myExpression ~= this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case "THAN":
                if (myCurrentCategory == "VALUES") {
                    // followed by parenthesis and (value-list or expr)
                   myExpression ~= this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case "MAXVALUE":
                if (myCurrentCategory == "VALUES") {
                   myExpression ~= this.getConstantType(strippedToken);

                    mylast = array_pop(myparsed["sub_tree"]);
                    mylast["base_expr"] = baseExpression;
                    mylast["sub_tree"] ~= myExpression;

                    baseExpression = mylast["storage"] . baseExpression;
                    unset(mylast["storage"]);
                    myparsed["sub_tree"] ~= mylast;
                    myparsed["base_expr"] = baseExpression.strip;

                   myExpression = myparsed["sub_tree"];
                    unset(mylast);
                   myCurrentCategory = myPreviousCategory;
                }
                // else ?
                break;

            case "IN":
                if (myCurrentCategory == "VALUES") {
                    // followed by parenthesis and value-list
                   myExpression ~= this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case "COMMENT":
                if (myPreviousCategory == "PARTITION") {
                   myExpression ~= createExpression(PARTITION_COMMENT, "base_expr" : false,
                                    "sub_tree" : false, "storage" : substr(baseExpression, 0, - mytoken.length));

                    myparsed["sub_tree"] ~= myExpression;
                    baseExpression = mytoken;
                   myExpression = [this.getReservedType(strippedToken));

                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "STORAGE":
                if (myPreviousCategory == "PARTITION") {
                    // followed by ENGINE
                   myExpression ~= createExpression("ENGINE"), "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, - mytoken.length));

                    myparsed["sub_tree"] ~= myExpression;
                    baseExpression = mytoken;
                   myExpression = [this.getReservedType(strippedToken));

                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "ENGINE":
                if (myCurrentCategory == "STORAGE") {
                   myExpression ~= this.getReservedType(strippedToken);
                   myCurrentCategory = upperToken;
                    continue 2;
                }
                if (myPreviousCategory == "PARTITION") {
                   myExpression ~= createExpression(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, - mytoken.length));

                    myparsed["sub_tree"] ~= myExpression;
                    baseExpression = mytoken;
                   myExpression = [this.getReservedType(strippedToken));

                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "=":
                if (in_array(myCurrentCategory, ["ENGINE", "COMMENT", "DIRECTORY", "MAX_ROWS", "MIN_ROWS"))) {
                   myExpression ~= this.getOperatorType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case ",":
                if (myPreviousCategory == "PARTITION" && myCurrentCategory.isEmpty) {
                    // it separates the partition-definitions
                    myresult ~= myparsed;
                    myparsed = [];
                    baseExpression = "";
                   myExpression = [];
                }
                break;

            case "DATA":
            case "INDEX":
                if (myPreviousCategory == "PARTITION") {
                    // followed by DIRECTORY
                   myExpression ~= ["expr_type" : constant("SqlParser\utils\expressionType(PARTITION_" . upperToken . "_DIR"),
                                    "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, - mytoken.length));

                    myparsed["sub_tree"] ~= myExpression;
                    baseExpression = mytoken;
                   myExpression = [this.getReservedType(strippedToken));

                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "DIRECTORY":
                if (myCurrentCategory == "DATA" || myCurrentCategory == "INDEX") {
                   myExpression ~= this.getReservedType(strippedToken);
                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "MAX_ROWS":
            case "MIN_ROWS":
                if (myPreviousCategory == "PARTITION") {
                   myExpression ~= ["expr_type" : constant("SqlParser\utils\expressionType(PARTITION_" . upperToken),
                                    "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, - mytoken.length));

                    myparsed["sub_tree"] ~= myExpression;
                    baseExpression = mytoken;
                   myExpression = [this.getReservedType(strippedToken));

                   myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            default:
                switch (myCurrentCategory) {

                case "MIN_ROWS":
                case "MAX_ROWS":
                case "ENGINE":
                case "DIRECTORY":
                case "COMMENT":
                   myExpression ~= this.getConstantType(strippedToken);

                    mylast = array_pop(myparsed["sub_tree"]);
                    mylast["sub_tree"] ~= myExpression;
                    mylast["base_expr"] = baseExpression.strip;
                    baseExpression = mylast["storage"] . baseExpression;
                    unset(mylast["storage"]);

                    myparsed["sub_tree"] ~= mylast;
                    myparsed["base_expr"] = baseExpression.strip;

                   myExpression = myparsed["sub_tree"];
                    unset(mylast);

                   myCurrentCategory = myPreviousCategory;
                    break;

                case "PARTITION":
                // that is the partition name
                    mylast = array_pop(myExpression);
                    mylast["name"] = strippedToken;
                   myExpression ~= mylast;
                   myExpression ~= this.getConstantType(strippedToken);
                    myparsed["sub_tree"] ~= myExpression;
                    myparsed["base_expr"] = baseExpression.strip;
                    break;

                case "VALUES":
                // we have parenthesis and have to process an expression/in-list
                    mylast = this.getBracketExpressionType(strippedToken);

                    myres = this.processExpressionList(strippedToken);
                    mylast["sub_tree"] ~= (myres.isEmpty ? false : myres);
                   myExpression ~= mylast;

                    mylast = array_pop(myparsed["sub_tree"]);
                    mylast["base_expr"] = baseExpression;
                    mylast["sub_tree"] ~= myExpression;

                    baseExpression = mylast["storage"] . baseExpression;
                    unset(mylast["storage"]);
                    myparsed["sub_tree"] ~= mylast;
                    myparsed["base_expr"] = baseExpression.strip;

                   myExpression = myparsed["sub_tree"];
                    unset(mylast);

                   myCurrentCategory = myPreviousCategory;
                    break;

                case "":
                    if (myPreviousCategory == "PARTITION") {
                        // last part to process, it is only one token!
                        if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                            mylast = this.getBracketExpressionType(strippedToken);
                            mylast["sub_tree"] ~= this.processSubpartitionDefinition(strippedToken);
                           myExpression ~= mylast;
                            unset(mylast);

                            myparsed["base_expr"] = baseExpression.strip;
                            myparsed["sub_tree"] ~= myExpression;

                           myCurrentCategory = myPreviousCategory;
                            break;
                        }
                    }
                    // else ?
                    break;

                default:
                    break;
                }
                break;
            }

           myPreviousCategory = myCurrentCategory;
           myCurrentCategory = "";
        }

        myresult ~= myparsed;
        return myresult;
    }
}
