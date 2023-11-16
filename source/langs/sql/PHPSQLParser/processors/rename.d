module langs.sql.PHPSQLParser.processors.rename;

import lang.sql;

@safe:

/**
 * This file : the processor for the RENAME statements.
 * This class processes the RENAME statements.
 */
class RenameProcessor : AbstractProcessor {

    auto process($tokenList) {
        baseExpression = "";
        $resultList = [];
        $tablePair = [];

        foreach ($k : myValue; $tokenList) {
            $token = new ExpressionToken(myKey, myValue);

            if ($token.isWhitespaceToken()) {
                continue;
            }

            switch ($token.getUpper()) {
            case 'TO':
            // separate source table from destination
                $tablePair["source"] = ["expr_type" : expressionType(TABLE, 'table' : baseExpression.strip,
                                             'no_quotes' : this.revokeQuotation(baseExpression),
                                             "base_expr" : baseExpression];
                baseExpression = "";
                break;

            case ',':
            // split rename operations
                $tablePair["destination"] = ["expr_type" : expressionType(TABLE, 'table' : baseExpression.strip,
                                                  'no_quotes' : this.revokeQuotation(baseExpression),
                                                  "base_expr" : baseExpression);
                $resultList[] = $tablePair;
                $tablePair = [];
                baseExpression = "";
                break;

            case 'TABLE':
                $objectType .isExpressionType(TABLE;
                $resultList[] = ["expr_type":expressionType("RESERVED"), "base_expr":$token.getTrim());   
                continue 2; 
                
            default:
                baseExpression  ~= $token.getToken();
                break;
            }
        }

        if (baseExpression != "") {
            $tablePair["destination"] = ["expr_type" : expressionType(TABLE, 'table' : baseExpression.strip,
                                              'no_quotes' : this.revokeQuotation(baseExpression),
                                              "base_expr" : baseExpression);
            $resultList[] = $tablePair;
        }

        return ["expr_type" : $objectType, "sub_tree":$resultList);
    }

}