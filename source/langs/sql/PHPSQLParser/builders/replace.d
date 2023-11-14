
/**
 * ReplaceBuilder.php
 *
 * Builds the [REPLACE] statement part. */

module source.langs.sql.PHPSQLParser.builders.replace;

import lang.sql;

@safe:

/**
 * This class : the builder for the [REPLACE] statement parts. 
 * You can overwrite all functions to achieve another handling. */
class ReplaceBuilder : ISqlBuilder {

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
        auto myBuilder = new ReplaceColumnListBuilder();
        return myBuilder.build($parsed, 0);
    }

    string build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildTable(myValue);
            mySql  ~= this.buildSubQuery(myValue);
            mySql  ~= this.buildColumnList(myValue);
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('REPLACE', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }
        return 'REPLACE ' . substr(mySql, 0, -1);
    }

}
