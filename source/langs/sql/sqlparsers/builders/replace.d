module langs.sql.sqlparsers.builders.replace;

import lang.sql;

@safe:

/**
 * Builds the [REPLACE] statement part. 
 * This class : the builder for the [REPLACE] statement parts. 
 * You can overwrite all functions to achieve another handling. */
class ReplaceBuilder : ISqlBuilder {

    protected auto buildTable(parsedSql) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, 0);
    }

    protected auto buildSubQuery(parsedSql) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql, 0);
    }

    protected auto buildReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildBracketExpression(parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildColumnList(parsedSql) {
        auto myBuilder = new ReplaceColumnListBuilder();
        return myBuilder.build(parsedSql, 0);
    }

    string build(Json parsedSql) {
        string mySql = "";
        foreach (myKey, myValue; parsedSql) {
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
