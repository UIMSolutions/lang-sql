
/**
 * WhereBuilder.php
 *
 * Builds the WHERE part.
 *
 *

 *
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the WHERE part.
 * You can overwrite all functions to achieve another handling.

 */
class WhereBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWhereExpression($parsed) {
        auto myBuilder = new WhereExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWhereBracketExpression($parsed) {
        auto myBuilder = new WhereBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
      auto myBuilder = new ReservedBuilder();
      return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "WHERE ";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);

            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildSubQuery($v);
            $sql  ~= this.buildInList($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildWhereExpression($v);
            $sql  ~= this.buildWhereBracketExpression($v);
            $sql  ~= this.buildUserVariable($v);
            $sql  ~= this.buildReserved($v);
            
            if (strlen($sql) == $len) {
                throw new UnableToCreateSQLException('WHERE', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }

}
