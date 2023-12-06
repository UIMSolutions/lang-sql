module langs.sql.sqlparsers.processors.rename;

import lang.sql;

@safe:

// Processes the RENAME statements.
class RenameProcessor : Processor {

    Json process(mytokenList) {
        string baseExpression = "";
        myresultList = [];
        mytablePair = [];

        foreach (myKey, myValue; mytokenList) {
            auto myToken = new ExpressionToken(myKey, myValue);

            if (myToken.isWhitespaceToken()) {
                continue;
            }

            switch (myToken.getUpper()) {
            case "TO":
            // separate source table from destination
                mytablePair["source"] = createExpression("TABLE", baseExpression);
                mytablePair["table"] = baseExpression.strip;
                mytablePair["no_quotes"] = this.revokeQuotation(baseExpression);
                                      
                baseExpression = "";
                break;

            case ",":
            // split rename operations
                mytablePair["destination"] = createExpression("TABLE", baseExpression);
                mytablePair["table"] = baseExpression.strip,
                mytablePair["no_quotes"] = this.revokeQuotation(baseExpression),
                    
                myresultList ~= mytablePair;
                mytablePair = [];
                baseExpression = "";
                break;

            case "TABLE":
                myobjectType .isExpressionType(TABLE;
                myresultList ~= ["expr_type":expressionType("RESERVED", myToken.strip)];   
                continue 2; 
                
            default:
                baseExpression ~= myToken.getToken();
                break;
            }
        }

        if (baseExpression != "") {
            mytablePair["destination"] = createExpression("TABLE"), "table" : baseExpression.strip,
                                              "no_quotes" : this.revokeQuotation(baseExpression),
                                              "base_expr" : baseExpression];
            myresultList ~= mytablePair;
        }

        return ["expr_type" : myobjectType, "sub_tree": myresultList];
    }

}