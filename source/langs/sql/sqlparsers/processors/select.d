module langs.sql.sqlparsers.processors.select;

import lang.sql;

@safe:
// This class processes the SELECT statements.
class SelectProcessor : SelectExpressionProcessor {

    auto process( mytokens) {
        string expression = "";
         myexpressionList = [];
        foreach (myToken;  mytokens) {
            if (this.isCommaToken(myToken)) {
                expression = super.process(expression.strip);
                expression["delim"] = ",";
                 myexpressionList ~= expression;
                expression = "";
            } else if (this.isCommentToken(myToken)) {
                 myexpressionList ~= super.processComment(myToken];
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
                    expression = super.process(myToken.strip);
                    expression["delim"] = " ";
                     myexpressionList ~= expression;
                    expression = "";
                    break;

                default:
                    expression ~= myToken;
                }
            }
        }
        if (expression) {
            expression = super.process(expression.strip);
            expression["delim"] = false;
             myexpressionList ~= expression;
        }
        return  myexpressionList;
    }
}
