module langs.sql.sqlparsers.processors.select;

import langs.sql;

@safe:
// This class processes the SELECT statements.
class SelectProcessor : SelectExpressionProcessor {

    Json process(strig[] tokens) {
        Json expression;
        Json myexpressionList = Json.emptyArray;
        foreach (myToken; mytokens) {
            processToken
        }
        if (expression) {
            expression = super.process(expression.strip);
            expression["delim"] = false;
            myexpressionList ~= expression;
        }
        return myexpressionList;
    }

    protected Json processToken(string token, Json expressionList = Json.emptyArray) {
        Json expression;

        if (this.isCommaToken(token)) {
            expression = super.process(token.strip);
            expression["delim"] = ",";
            myexpressionList ~= expression;
        } else if (this.isCommentToken(token)) {
            myexpressionList ~= super.processComment(token);
        } else {
            switch (token.toUpper) {

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
                expression = super.process(token.strip);
                expression["delim"] = " ";
                myexpressionList ~= expression;
                break;

            default:
                expression ~= myToken;
                break;
            }
        }

        return expressionList;
    }
}
