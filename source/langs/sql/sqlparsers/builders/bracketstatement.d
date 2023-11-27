module lang.sql.parsers.builders;

import lang.sql;

@safe:
// Builds the parentheses around a statement. */
class BracketStatementBuilder : ISqlBuilder {

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

    protected string buildKeyValue(string aKey, Json aValue) {
        string result;
        return result;
    }

    protected string buildSelectBracketExpression(Json parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql, " ");
    }

    protected string buildSelectStatement(Json parsedSql) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSql);
    }
}
