module langs.sql.parsers.processors.drop;

import langs.sql;

@safe:

/**
 * This file : the processor for the DROP statements.
 * This class processes the DROP statements.
 */
class DropProcessor : Processor {

    Json process(mytokenList) {
        bool exists = false;
        string baseExpression = "";
        auto objectType = "";
        Json mySubTree;
        myoption = false;

        foreach (myToken; mytokenList) {
            baseExpression ~= myToken;
            string strippedToken = myToken.strip;

            if (strippedToken.isEmpty) {
                continue;
            }

            string upperToken = strippedToken.toUpper;
            switch (upperToken) {
            case "VIEW":
            case "SCHEMA":
            case "DATABASE":
            case "TABLE":
                if (objectType.isEmpty) {
                    objectType = constant("SqlParser\utils\expressionType(" ~ upperToken);
                }
                baseExpression = "";
                break;
            case "INDEX":
	            if (objectType.isEmpty ) {
		            objectType = constant("SqlParser\utils\expressionType(" ~ upperToken );
	            }
	            baseExpression = "";
	            break;
            case "IF":
            case "EXISTS":
                exists = true;
                baseExpression = "";
                break;

            case "TEMPORARY":
                objectType = expressionType("TEMPORARY_TABLE");
                baseExpression = "";
                break;

            case "RESTRICT":
            case "CASCADE":
                myoption = upperToken;
                if (!myobjectList.isEmpty) {
                    mySubTree = createExpression("EXPRESSION", substr(baseExpression, 0, -myToken.length).strip);
                    mySubTree["sub_tree"] ~= myobjectList;
                    myobjectList = [];
                }
                baseExpression = "";
                break;

            case ",":
                mylast = array_pop(myobjectList);
                mylast["delim"] = strippedToken;
                myobjectList ~= mylast;
                continue 2;

            default:
                Json myObject = [];
                myObject["expr_type"] = objectType;
                if (objectType.isExpressionType("TABLE") || objectType.isExpressionType("TEMPORARY_TABLE")) {
                    myObject["table"] = strippedToken;
                    myObject["no_quotes"] = false;
                    myObject["alias"] = false;
                }
                myObject["base_expr"] = strippedToken;
                myObject["no_quotes"] = this.revokeQuotation(strippedToken);
                myObject["delim"] = false;

                myobjectList ~= myObject;
                continue 2;
            }

            mySubTree ~= createExpression("RESERVED"), "base_expr" : strippedToken);
        }

        if (!myobjectList.isEmpty) {
            Json newExpression = createExpression("EXPRESSION", baseExpression.strip);
            newExpression["sub_tree"] ~= myobjectList;
            mySubTree ~= newExpression;
        }

        return ["expr_type" : objectType, "option" : myoption, "if-exists" : exists, "sub_tree" : mySubTree);
    }
}
