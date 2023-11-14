
/**
 * RenameProcessor.php
 *
 * This file : the processor for the RENAME statements.
 *
 *

 *
 */

module lang.sql.parsers.processors;
use SqlParser\utils\ExpressionType;
use SqlParser\utils\ExpressionToken;

/**
 * This class processes the RENAME statements.

 */
class RenameProcessor : AbstractProcessor {

    auto process($tokenList) {
        $base_expr = "";
        $resultList = array();
        $tablePair = array();

        foreach ($tokenList as $k => $v) {
            $token = new ExpressionToken($k, $v);

            if ($token.isWhitespaceToken()) {
                continue;
            }

            switch ($token.getUpper()) {
            case 'TO':
            // separate source table from destination
                $tablePair["source"] = array('expr_type' => ExpressionType::TABLE, 'table' => trim($base_expr),
                                             'no_quotes' => this.revokeQuotation($base_expr),
                                             'base_expr' => $base_expr);
                $base_expr = "";
                break;

            case ',':
            // split rename operations
                $tablePair["destination"] = array('expr_type' => ExpressionType::TABLE, 'table' => trim($base_expr),
                                                  'no_quotes' => this.revokeQuotation($base_expr),
                                                  'base_expr' => $base_expr);
                $resultList[] = $tablePair;
                $tablePair = array();
                $base_expr = "";
                break;

            case 'TABLE':
                $objectType = ExpressionType::TABLE;
                $resultList[] = array('expr_type'=>ExpressionType::RESERVED, 'base_expr'=>$token.getTrim());   
                continue 2; 
                
            default:
                $base_expr  ~= $token.getToken();
                break;
            }
        }

        if ($base_expr != "") {
            $tablePair["destination"] = array('expr_type' => ExpressionType::TABLE, 'table' => trim($base_expr),
                                              'no_quotes' => this.revokeQuotation($base_expr),
                                              'base_expr' => $base_expr);
            $resultList[] = $tablePair;
        }

        return array('expr_type' => $objectType, 'sub_tree'=>$resultList);
    }

}