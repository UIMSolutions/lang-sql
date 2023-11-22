module langs.sql.sqlparsers.builders.replace;

import lang.sql;

@safe:

/**
 * Builds the [REPLACE] statement part. 
 * This class : the builder for the [REPLACE] statement parts. 
 * You can overwrite all functions to achieve another handling. */
class ReplaceBuilder : ISqlBuilder {

    protected auto buildTable(parsedSQL) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSQL, 0);
    }

    protected auto buildSubQuery(parsedSQL) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSQL, 0);
    }

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildBracketExpression(parsedSQL) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildColumnList(parsedSQL) {
        auto myBuilder = new ReplaceColumnListBuilder();
        return myBuilder.build(parsedSQL, 0);
    }

    string build(Json parsedSQL) {
        string mySql = "";
        foreach (myKey, myValue; parsedSQL) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildTable(myValue);
            mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildColumnList(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("REPLACE", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return "REPLACE " ~ substr(mySql, 0, -1);
    }

}
