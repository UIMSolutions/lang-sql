
/**
 * OptionsProcessor.php
 *
 * This file : the processor for the statement options.
 */

module langs.sql.PHPSQLParser.processors.options;

import lang.sql;

@safe:

// This class processes the statement options.
class OptionsProcessor : AbstractProcessor {

    auto process($tokens) {
        $resultList = array();

        foreach ($tokens as $token) {

            $tokenList = this.splitSQLIntoTokens($token);
            $result = array();

            foreach (myReserved; $tokenList) {
                $trim = myReserved.strip;
                if ($trim == '') {
                    continue;
                }
                $result[] = array('expr_type' :  ExpressionType::RESERVED, 'base_expr' :  $trim);
            }
            $resultList[] = array('expr_type' :  ExpressionType::EXPRESSION, 'base_expr' :  $token.strip,
                                  'sub_tree' :  $result);
        }

        return $resultList;
    }
}

?>
