module langs.sql.PHPSQLParser.builders.insert.builder;

import lang.sql;

@safe:

/**
 * Builds the [INSERT] statement part.
 * This class : the builder for the [INSERT] statement parts. 
 * You can overwrite all functions to achieve another handling. */
class InsertBuilder : ISqlBuilder {

    protected auto buildTable($parsed) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, 0);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build($parsed, 0);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        auto myBuilder = new InsertColumnListBuilder();
        return myBuilder.build($parsed, 0);
    }

    string build(array $parsed) {
        string mySql = "";
        foreach (myKey, myValue; $parsed) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildTable(myValue);
            mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildColumnList(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('INSERT', myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return 'INSERT ' . substr(mySql, 0, -1);
    }

}
