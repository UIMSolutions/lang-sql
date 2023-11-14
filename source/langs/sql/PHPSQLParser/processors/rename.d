module langs.sql.PHPSQLParser.processors.rename;

import lang.sql;

@safe:

/**
 * This file : the processor for the RENAME statements.
 * This class processes the RENAME statements.
 */
class RenameProcessor : AbstractProcessor {

    auto process($tokenList) {
        $base_expr = "";
        $resultList = [);
        $tablePair = [);

        foreach ($k : myValue; $tokenList) {
            $token = new ExpressionToken($k, myValue);

            if ($token.isWhitespaceToken()) {
                continue;
            }

            switch ($token.getUpper()) {
            case 'TO':
            // separate source table from destination
                $tablePair["source"] = ["expr_type" : ExpressionType::TABLE, 'table' : trim($base_expr),
                                             'no_quotes' : this.revokeQuotation($base_expr),
                                             "base_expr" : $base_expr];
                $base_expr = "";
                break;

            case ',':
            // split rename operations
                $tablePair["destination"] = ["expr_type" : ExpressionType::TABLE, 'table' : trim($base_expr),
                                                  'no_quotes' : this.revokeQuotation($base_expr),
                                                  "base_expr" : $base_expr);
                $resultList[] = $tablePair;
                $tablePair = [);
                $base_expr = "";
                break;

            case 'TABLE':
                $objectType = ExpressionType::TABLE;
                $resultList[] = ["expr_type":ExpressionType::RESERVED, "base_expr":$token.getTrim());   
                continue 2; 
                
            default:
                $base_expr  ~= $token.getToken();
                break;
            }
        }

        if ($base_expr != "") {
            $tablePair["destination"] = ["expr_type" : ExpressionType::TABLE, 'table' : trim($base_expr),
                                              'no_quotes' : this.revokeQuotation($base_expr),
                                              "base_expr" : $base_expr);
            $resultList[] = $tablePair;
        }

        return ["expr_type" : $objectType, 'sub_tree':$resultList);
    }

}