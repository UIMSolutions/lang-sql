module lang.sql.parsers.builders;

import lang.sql;

@safe:
// Builds the parentheses around a statement. */
class BracketStatementBuilder : ISqlBuilder {

    protected auto buildSelectBracketExpression(parsedSQL) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSQL, " ");
    }

    protected auto buildSelectStatement(parsedSQL) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = "";
        foreach (myKey, myValue; parsedSQL["BRACKET"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildSelectBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("BRACKET", myKey, myValue, "expr_type");
            }
        }
        return mySql ~ " " ~ this.buildSelectStatement(parsedSQL).strip).strip;
    }
}
