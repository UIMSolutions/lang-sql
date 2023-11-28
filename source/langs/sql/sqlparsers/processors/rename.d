module langs.sql.sqlparsers.processors.rename;

import lang.sql;

@safe:

/**
 * This class processes the RENAME statements.
 */
class RenameProcessor : AbstractProcessor {

    auto process($tokenList) {
        string baseExpression = "";
        $resultList = [];
        $tablePair = [];

        foreach (myKey, myValue; $tokenList) {
            auto myToken = new ExpressionToken(myKey, myValue);

            if (myToken.isWhitespaceToken()) {
                continue;
            }

            switch (myToken.getUpper()) {
            case "TO":
            // separate source table from destination
                $tablePair["source"] = createExpression("TABLE"), "table" : baseExpression.strip,
                                             "no_quotes" : this.revokeQuotation(baseExpression),
                                             "base_expr" : baseExpression];
                baseExpression = "";
                break;

            case ",":
            // split rename operations
                $tablePair["destination"] = createExpression("TABLE"), "table" : baseExpression.strip,
                                                  "no_quotes" : this.revokeQuotation(baseExpression),
                                                  "base_expr" : baseExpression];
                $resultList[] = $tablePair;
                $tablePair = [];
                baseExpression = "";
                break;

            case "TABLE":
                $objectType .isExpressionType(TABLE;
                $resultList[] = ["expr_type":expressionType("RESERVED"), "base_expr":myToken.getTrim()];   
                continue 2; 
                
            default:
                baseExpression ~= myToken.getToken();
                break;
            }
        }

        if (baseExpression != "") {
            $tablePair["destination"] = ["expr_type" : expressionType("TABLE"), "table" : baseExpression.strip,
                                              "no_quotes" : this.revokeQuotation(baseExpression),
                                              "base_expr" : baseExpression];
            $resultList[] = $tablePair;
        }

        return ["expr_type" : $objectType, "sub_tree":$resultList];
    }

}