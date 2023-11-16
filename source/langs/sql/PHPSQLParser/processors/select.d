module langs.sql.PHPSQLParser.processors.select;

import lang.sql;

@safe:
/**
 * This file : the processor for the SELECT statements.
 * This class processes the SELECT statements.
 */
class SelectProcessor : SelectExpressionProcessor {

    auto process($tokens) {
        $expression = "";
        $expressionList = [];
        foreach (myToken; $tokens) {
            if (this.isCommaToken(myToken)) {
                $expression = super.process($expression.strip);
                $expression["delim"] = ",";
                $expressionList[] = $expression;
                $expression = "";
            } else if (this.isCommentToken(myToken)) {
                $expressionList[] = super.processComment(myToken];
            } else {
                switch (myToken.toUpper) {

                // add more SELECT options here
                case "DISTINCT":
                case "DISTINCTROW":
                case "HIGH_PRIORITY":
                case "SQL_CACHE":
                case "SQL_NO_CACHE":
                case "SQL_CALC_FOUND_ROWS":
                case "STRAIGHT_JOIN":
                case "SQL_SMALL_RESULT":
                case "SQL_BIG_RESULT":
                case "SQL_BUFFER_RESULT":
                    $expression = super.process(myToken.strip);
                    $expression["delim"] = " ";
                    $expressionList[] = $expression;
                    $expression = "";
                    break;

                default:
                    $expression ~= myToken;
                }
            }
        }
        if ($expression) {
            $expression = super.process($expression.strip);
            $expression["delim"] = false;
            $expressionList[] = $expression;
        }
        return $expressionList;
    }
}
