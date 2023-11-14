
/**
 * ReplaceBuilder.php
 *
 * Builds the [REPLACE] statement part.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the [REPLACE] statement parts. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class ReplaceBuilder : ISqlBuilder {

    protected auto buildTable($parsed) {
        $builder = new TableBuilder();
        return $builder.build($parsed, 0);
    }

    protected auto buildSubQuery($parsed) {
        $builder = new SubQueryBuilder();
        return $builder.build($parsed, 0);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildBracketExpression($parsed) {
        $builder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        $builder = new ReplaceColumnListBuilder();
        return $builder.build($parsed, 0);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildTable($v);
            $sql  ~= this.buildSubQuery($v);
            $sql  ~= this.buildColumnList($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildBracketExpression($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('REPLACE', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return 'REPLACE ' . substr($sql, 0, -1);
    }

}
