module lang.sql.parsers.builders;

import lang.sql;

@safe:
// Builds the parentheses around a statement. */
class BracketStatementBuilder : ISqlBuilder {

    protected auto buildSelectBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build($parsed, " ");
    }

    protected auto buildSelectStatement($parsed) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        string mySql = "";
        foreach (myKey, myValue; $parsed["BRACKET"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildSelectBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('BRACKET', myKey, myValue, "expr_type");
            }
        }
        return mySql ~ " " ~ this.buildSelectStatement($parsed).strip).strip;
    }
}
