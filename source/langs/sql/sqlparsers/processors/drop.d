module langs.sql.sqlparsers.processors.drop;

import lang.sql;

@safe:

/**
 * This file : the processor for the DROP statements.
 * This class processes the DROP statements.
 */
class DropProcessor : AbstractProcessor {

    auto process( mytokenList) {
        bool exists = false;
        string baseExpression = "";
        auto objectType = "";
        Json subTree;
         myoption = false;

        foreach (myToken;  mytokenList) {
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
	            if ( objectType.isEmpty ) {
		            objectType = constant( "SqlParser\utils\expressionType(" ~ upperToken );
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
                if (!empty( myobjectList)) {
                    subTree = createExpression("EXPRESSION", substr(baseExpression, 0, -myToken.length).strip);
                    subTree["sub_tree"] =  myobjectList;
                     myobjectList = [];
                }
                baseExpression = "";
                break;

            case ",":
                 mylast = array_pop( myobjectList);
                 mylast["delim"] = strippedToken;
                 myobjectList[] =  mylast;
                continue 2;

            default:
                 myobject = [];
                 myobject["expr_type"] = objectType;
                if (objectType.isExpressionType("TABLE") || objectType.isExpressionType("TEMPORARY_TABLE")) {
                     myobject["table"] = strippedToken;
                     myobject["no_quotes"] = false;
                     myobject["alias"] = false;
                }
                 myobject["base_expr"] = strippedToken;
                 myobject["no_quotes"] = this.revokeQuotation(strippedToken);
                 myobject["delim"] = false;

                 myobjectList[] =  myobject;
                continue 2;
            }

             mysubTree[] = createExpression("RESERVED"), "base_expr" : strippedToken);
        }

        if (!empty( myobjectList)) {
             mysubTree[] = createExpression("EXPRESSION"), "base_expr" : baseExpression.strip,
                               "sub_tree" :  myobjectList];
        }

        return ["expr_type" : objectType, "option" :  myoption, "if-exists" : exists, "sub_tree" :  mysubTree);
    }
}
