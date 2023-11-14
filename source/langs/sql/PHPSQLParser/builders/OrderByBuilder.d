
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
        mySql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildAlias($v);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildExpression($v);
            mySql  ~= this.buildBracketExpression($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildPosition($v);
            
            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('ORDER', $k, $v, 'expr_type');
            }

            mySql  ~= ", ";
        }
        mySql = substr(mySql, 0, -2);
        return "ORDER BY " . mySql;
    }
}
