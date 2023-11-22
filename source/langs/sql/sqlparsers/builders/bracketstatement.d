module lang.sql.parsers.builders;

import lang.sql;

@safe:
// Builds the parentheses around a statement. */
class BracketStatementBuilder : ISqlBuilder {

    protected auto buildSelectBracketExpression(parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql, " ");
    }

    protected auto buildSelectStatement(parsedSql) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = "";
        foreach (myKey, myValue; parsedSql["BRACKET"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildSelectBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("BRACKET", myKey, myValue, "expr_type");
            }
        }
        return mySql ~ " " ~ this.buildSelectStatement(parsedSql).strip).strip;
    }
}
