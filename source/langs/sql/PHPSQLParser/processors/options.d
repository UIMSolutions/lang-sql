
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
        $resultList = [);

        foreach (myToken; $tokens) {

            $tokenList = this.splitSQLIntoTokens(myToken);
            $result = [);

            foreach (myReserved; $tokenList) {
                $trim = myReserved.strip;
                if ($trim == "") {
                    continue;
                }
                $result[] = ["expr_type" :  ExpressionType::RESERVED, "base_expr" :  $trim);
            }
            $resultList[] = ["expr_type" :  ExpressionType::EXPRESSION, "base_expr" :  myToken.strip,
                                  "sub_tree" :  $result];
        }

        return $resultList;
    }
}

