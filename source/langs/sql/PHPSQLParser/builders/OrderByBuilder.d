
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
        myBuilder = new OrderByFunctionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildReserved($parsed) {
        myBuilder = new OrderByReservedBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildColRef($parsed) {
        myBuilder = new OrderByColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        myBuilder = new OrderByAliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildExpression($parsed) {
        myBuilder = new OrderByExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildBracketExpression($parsed) {
        myBuilder = new OrderByBracketExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildPosition($parsed) {
        myBuilder = new OrderByPositionBuilder();
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
