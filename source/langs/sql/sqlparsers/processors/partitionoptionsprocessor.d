module lang.sql.parsers.processors;

import lang.sql;

@safe:

// This class processes the PARTITION BY statements within CREATE TABLE.
class PartitionOptionsProcessor : AbstractProcessor {

    protected auto processExpressionList( myunparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        auto myExpression = this.removeParenthesisFromStart( myunparsed);
       myExpression = this.splitSQLIntoTokens(myExpression);
        return myProcessor.process(myExpression);
    }

    protected auto processColumnList( myunparsed) {
        auto myProcessor = new ColumnListProcessor(this.options);
       myExpression = this.removeParenthesisFromStart( myunparsed);
        return myProcessor.process(myExpression);
    }

    protected auto processPartitionDefinition( myunparsed) {
        auto myProcessor = new PartitionDefinitionProcessor(this.options);
        auto myExpression = this.removeParenthesisFromStart( myunparsed);
       myExpression = this.splitSQLIntoTokens(myExpression);
        return myProcessor.process(myExpression);
    }

    protected auto getReservedType( mytoken) {
        return createExpression("RESERVED", mytoken];
    }

    protected auto getConstantType( mytoken) {
        return createExpression("CONSTANT", mytoken];
    }

    protected auto getOperatorType( mytoken) {
        return createExpression("OPERATOR", mytoken];
    }

    protected auto getBracketExpressionType( mytoken) {
        return createExpression("BRACKET_EXPRESSION", mytoken, "sub_tree" : false];
    }

    auto process( mytokens) {

        Json result = Json.emptyObject;
        result["partition-options"] = Json.emptyArray;
        result["last-parsed"] = false;

        string previousCategory = "";
        string currentCategory = "";
        myparsed = [];
        auto myExpression = [];
        string baseExpression = "";
        int skipMode = 0;

        foreach ( mytokenKey, mytoken; mytokens) {
            auto strippedToken = mytoken.strip;
            baseExpression ~= mytoken;

            if (skipMode > 0) {
                skipMode--;
                continue;
            }

            if (skipMode < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            auto upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case "PARTITION":
                currentCategory = upperToken;
               myExpression ~= this.getReservedType(strippedToken);
                parsed = createExpression("PARTITION", baseExpression.strip);
                parsed["sub_tree"] = false;
                break;

            case "SUBPARTITION":
                currentCategory = upperToken;
               myExpression ~= this.getReservedType(strippedToken);
                parsed = createExpression("SUBPARTITION", baseExpression.strip);
                parsed["sub_tree"] = false;
                break;

            case "BY":
                if (previousCategory == "PARTITION" || previousCategory == "SUBPARTITION") {
                   myExpression ~= this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case "PARTITIONS":
            case "SUBPARTITIONS":
                currentCategory = "PARTITION_NUM";
               myExpression = ["expr_type" : constant("SqlParser\utils\expressionType(" . substr(upperToken, 0, -1) ~ "_COUNT"),
                              "base_expr" : false, "sub_tree" : [this.getReservedType(strippedToken)),
                              "storage" : substr(baseExpression, 0, - mytoken.length));
                baseExpression = mytoken;
                continue 2;

            case "LINEAR":
            // followed by HASH or KEY
                currentCategory = upperToken;
               myExpression ~= this.getReservedType(strippedToken);
                continue 2;

            case "HASH":
            case "KEY":
               myExpression ~= ["expr_type" : constant("SqlParser\utils\expressionType(" ~ previousCategory ~ "_" . upperToken),
                                "base_expr" : false, "linear" : (currentCategory == "LINEAR"), "sub_tree" : false,
                                "storage" : substr(baseExpression, 0, - mytoken.length));

                mylast = array_pop( myparsed);
                mylast["by"] = (currentCategory . " " ~ upperToken).strip; // currentCategory will be empty or LINEAR!
                mylast["sub_tree"] = myExpression;
                myparsed ~= mylast;

                baseExpression = mytoken;
               myExpression = [this.getReservedType(strippedToken)];

                currentCategory = upperToken;
                continue 2;

            case "ALGORITHM":
                if (currentCategory == "KEY") {
                   myExpression ~= ["expr_type" : constant("SqlParser\utils\expressionType(" ~ previousCategory ~ "_KEY_ALGORITHM"),
                                    "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, - mytoken.length));

                    mylast = array_pop( myparsed);
                    mysubtree = array_pop( mylast["sub_tree"]);
                    mysubtree["sub_tree"] = myExpression;
                    mylast["sub_tree"] ~= mysubtree;
                    myparsed ~= mylast;
                    unset( mysubtree);
                    unset( mylast);

                    baseExpression = mytoken;
                   myExpression = [this.getReservedType(strippedToken));
                    currentCategory = upperToken;
                    continue 2;
                }
                break;

            case "RANGE":
            case "LIST":
               myExpression ~= ["expr_type" : constant("SqlParser\utils\expressionType(PARTITION_" . upperToken, false,
                                "sub_tree" : false, "storage" : substr(baseExpression, 0, - mytoken.length));

                mylast = array_pop( myparsed);
                mylast["by"] = upperToken;
                mylast["sub_tree"] = myExpression;
                myparsed ~= mylast;
                unset( mylast);

                baseExpression = mytoken;
               myExpression = [this.getReservedType(strippedToken));

                currentCategory = upperToken . "_EXPR";
                continue 2;

            case "COLUMNS":
                if (currentCategory == "RANGE_EXPR" || currentCategory == "LIST_EXPR") {
                   myExpression ~= this.getReservedType(strippedToken);
                    currentCategory = substr(currentCategory, 0, -4) ~ upperToken;
                    continue 2;
                }
                break;

            case "=":
                if (currentCategory == "ALGORITHM") {
                    // between ALGORITHM and a constant
                   myExpression ~= this.getOperatorType(strippedToken);
                    continue 2;
                }
                break;

            default:
                switch (currentCategory) {

                case "PARTITION_NUM":
                // the number behind PARTITIONS or SUBPARTITIONS
                   myExpression["base_expr"] = baseExpression.strip;
                   myExpression["sub_tree"] ~= this.getConstantType(strippedToken);
                    baseExpression = myExpression["storage"] ~ baseExpression;
                    unset(myExpression["storage"]);

                    mylast = array_pop( myparsed);
                    mylast["count"] = strippedToken;
                    mylast["sub_tree"] ~= myExpression;
                    mylast.baseExpression ~= baseExpression;
                    myparsed ~= mylast;
                    unset( mylast);

                   myExpression = [];
                    baseExpression = "";
                    currentCategory = previousCategory;
                    break;

                case "ALGORITHM":
                // the number of the algorithm
                   myExpression ~= this.getConstantType(strippedToken);

                    mylast = array_pop( myparsed);
                    mysubtree = array_pop( mylast["sub_tree"]);
                   myKey = array_pop( mysubtree["sub_tree"]);

                   myKey["sub_tree"] = myExpression;
                   myKey["base_expr"] = baseExpression.strip;

                    baseExpression = myKey["storage"] . baseExpression;
                    unset(myKey["storage"]);

                    mysubtree["sub_tree"] ~= myKey;
                    unset(myKey);

                   myExpression = mysubtree["sub_tree"];
                    mysubtree["sub_tree"] = false;
                    mysubtree["algorithm"] = strippedToken;
                    mylast["sub_tree"] ~= mysubtree;
                    unset( mysubtree);

                    myparsed ~= mylast;
                    unset( mylast);
                    currentCategory = "KEY";
                    continue 3;

                case "LIST_EXPR":
                case "RANGE_EXPR":
                case "HASH":
                // parenthesis around an expression
                    mylast = this.getBracketExpressionType(strippedToken);
                    myres = this.processExpressionList(strippedToken);
                    mylast["sub_tree"] = (empty( myres) ? false : myres);
                   myExpression ~= mylast;

                    mylast = array_pop( myparsed);
                    mysubtree = array_pop( mylast["sub_tree"]);
                    mysubtree["base_expr"] = baseExpression;
                    mysubtree["sub_tree"] = myExpression;

                    baseExpression = mysubtree["storage"] ~ baseExpression;
                    unset( mysubtree["storage"]);
                    mylast["sub_tree"] ~= mysubtree;
                    mylast["base_expr"] = baseExpression.strip;
                    myparsed ~= mylast;
                    unset( mylast);
                    unset( mysubtree);

                   myExpression = [];
                    baseExpression = "";
                    currentCategory = previousCategory;
                    break;

                case "LIST_COLUMNS":
                case "RANGE_COLUMNS":
                case "KEY":
                // the columnlist
                   myExpression = createExpression("COLUMN_LIST", strippedToken);
                   myExpression["sub_tree"] = this.processColumnList(strippedToken);

                    mylast = array_pop( myparsed);
                    mysubtree = array_pop( mylast["sub_tree"]);
                    mysubtree["base_expr"] = baseExpression;
                    mysubtree["sub_tree"] = myExpression;

                    baseExpression = mysubtree["storage"].get!string ~ baseExpression;
                    mysubtree.remove("storage");
                    mylast["sub_tree"] ~= mysubtree;
                    mylast["base_expr"] = baseExpression.strip;
                    myparsed ~= mylast;
                    unset( mylast);
                    unset( mysubtree);

                   myExpression = [];
                    baseExpression = "";
                    currentCategory = previousCategory;
                    break;

                case "":
                    if (previousCategory == "PARTITION" || previousCategory == "SUBPARTITION") {
                        if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                            // last part to process, it is only one token!
                            mylast = this.getBracketExpressionType(strippedToken);
                            mylast["sub_tree"] = this.processPartitionDefinition(strippedToken);
                            myparsed ~= mylast;
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

            previousCategory = currentCategory;
            currentCategory = "";
        }

        myresult["partition-options"] = myparsed;
        if ( myresult["last-parsed"] == false) {
            myresult["last-parsed"] = mytokenKey;
        }
        return myresult;
    }
}
