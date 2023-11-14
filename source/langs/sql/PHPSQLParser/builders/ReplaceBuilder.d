
/**
 * ReplaceBuilder.php
 *
 * Builds the [REPLACE] statement part.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the [REPLACE] statement parts. 
 * You can overwrite all functions to achieve another handling.
 */
class ReplaceBuilder : ISqlBuilder {

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
        auto myBuilder = new ReplaceColumnListBuilder();
        return $builder.build($parsed, 0);
    }

    auto build(array $parsed) {
        auto mySql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildTable($v);
            mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildBracketExpression($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('REPLACE', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return 'REPLACE ' . substr(mySql, 0, -1);
    }

}
