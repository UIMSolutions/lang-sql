
/**
 * InsertBuilder.php
 *
 * Builds the [INSERT] statement part.

 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the [INSERT] statement parts. 
 * You can overwrite all functions to achieve another handling.
 */
class InsertBuilder : ISqlBuilder {

    protected auto buildTable($parsed) {
        auto myBuilder = new TableBuilder();
        return $builder.build($parsed, 0);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return $builder.build($parsed, 0);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        auto myBuilder = new InsertColumnListBuilder();
        return $builder.build($parsed, 0);
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
