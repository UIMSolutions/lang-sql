module langs.sql.sqlparsers.builders.insert.builder;

import lang.sql;

@safe:

/**
 * Builds the [INSERT] statement part.
 * This class : the builder for the [INSERT] statement parts. 
 * You can overwrite all functions to achieve another handling. */
class InsertBuilder : ISqlBuilder {

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
        auto myBuilder = new InsertColumnListBuilder();
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
                throw new UnableToCreateSQLException("INSERT", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return "INSERT " . substr(mySql, 0, -1);
    }

}
