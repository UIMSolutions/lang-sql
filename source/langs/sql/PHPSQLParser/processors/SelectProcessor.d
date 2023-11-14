
/**
 * SelectProcessor.php
 *
 * This file : the processor for the SELECT statements.
 */

module lang.sql.parsers.processors;

import lang.sql;

@safe:
/**
 * 
 * This class processes the SELECT statements.
 * 
*/
class SelectProcessor : SelectExpressionProcessor {

    auto process($tokens) {
        $expression = "";
        $expressionList = array();
        foreach ($tokens as $token) {
            if (this.isCommaToken($token)) {
                $expression = super.process(trim($expression));
                $expression["delim"] = ',';
                $expressionList[] = $expression;
                $expression = "";
            } else if (this.isCommentToken($token)) {
                $expressionList[] = super.processComment($token);
            } else {
                switch (strtoupper($token)) {

                // add more SELECT options here
                case 'DISTINCT':
                case 'DISTINCTROW':
                case 'HIGH_PRIORITY':
                case 'SQL_CACHE':
                case 'SQL_NO_CACHE':
                case 'SQL_CALC_FOUND_ROWS':
                case 'STRAIGHT_JOIN':
                case 'SQL_SMALL_RESULT':
                case 'SQL_BIG_RESULT':
                case 'SQL_BUFFER_RESULT':
                    $expression = super.process(trim($token));
                    $expression["delim"] = " ";
                    $expressionList[] = $expression;
                    $expression = "";
                    break;

                default:
                    $expression  ~= $token;
                }
            }
        }
        if ($expression) {
            $expression = super.process(trim($expression));
            $expression["delim"] = false;
            $expressionList[] = $expression;
        }
        return $expressionList;
    }
}
