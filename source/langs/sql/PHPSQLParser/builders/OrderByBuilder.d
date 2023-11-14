
/**
 * OrderByBuilder.php
 *
 * Builds the ORDERBY clause.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class OrderByBuilder : ISqlBuilder {

    protected auto buildFunction($parsed) {
        $builder = new OrderByFunctionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildReserved($parsed) {
        $builder = new OrderByReservedBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildColRef($parsed) {
        $builder = new OrderByColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        $builder = new OrderByAliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildExpression($parsed) {
        $builder = new OrderByExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildBracketExpression($parsed) {
        $builder = new OrderByBracketExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildPosition($parsed) {
        $builder = new OrderByPositionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildAlias($v);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildExpression($v);
            $sql  ~= this.buildBracketExpression($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildPosition($v);
            
            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('ORDER', $k, $v, 'expr_type');
            }

            $sql  ~= ", ";
        }
        $sql = substr($sql, 0, -2);
        return "ORDER BY " . $sql;
    }
}
