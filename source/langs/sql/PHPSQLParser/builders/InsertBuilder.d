
/**
 * InsertBuilder.php
 *
 * Builds the [INSERT] statement part.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
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

    auto build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildTable($v);
            mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildBracketExpression($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('INSERT', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return 'INSERT ' . substr(mySql, 0, -1);
    }

}
