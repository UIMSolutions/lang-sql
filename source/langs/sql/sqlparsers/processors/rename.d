module langs.sql.sqlparsers.processors.rename;

import lang.sql;

@safe:

// Processes the RENAME statements.
class RenameProcessor : Processor {

    Json process(mytokenList) {
        string baseExpression = "";
        Json myresultList = Json.emptyArray;
        Json mytablePair = Json.emptyObject;

        foreach (myKey, myValue; mytokenList) {
            auto myToken = new ExpressionToken(myKey, myValue);

            if (myToken.isWhitespaceToken()) {
                continue;
            }

            switch (myToken.getUpper()) {
            case "TO":
                // separate source table from destination
                Json mytablePair["source"] = createExpression("TABLE", baseExpression);
                mytablePair["table"] = baseExpression.strip;
                mytablePair["no_quotes"] = this.revokeQuotation(baseExpression);
                                      
                baseExpression = "";
                break;

            case ",":
                // split rename operations
                Json mytablePair["destination"] = createExpression("TABLE", baseExpression);
                mytablePair["table"] = baseExpression.strip,
                mytablePair["no_quotes"] = this.revokeQuotation(baseExpression),
                    
                myresultList ~= mytablePair;
                mytablePair = [];
                baseExpression = "";
                break;

            case "TABLE":
                myobjectType = expressionType("TABLE");
                myresultList ~= createExpression("RESERVED", myToken.strip);   
                continue 2; 
                
            default:
                baseExpression ~= myToken.getToken();
                break;
            }
        }

        if (baseExpression != "") {
            Json newExpression = createExpression("TABLE", baseExpression);
            newExpression["table"] = baseExpression.strip;
            newExpression["no_quotes"] = this.revokeQuotation(baseExpression);
            Json mytablePair["destination"] = newExpression;
            myresultList ~= mytablePair;
        }

        Json result = Json.emptyObject;
        result["expr_type"] = myobjectType;
        result["sub_tree"] = myresultList;
        return result; 
    }

}