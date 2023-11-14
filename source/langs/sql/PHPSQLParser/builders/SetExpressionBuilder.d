
/**
 * SetExpressionBuilder.php
 *
 * Builds the SET part of the INSERT statement.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling.
 */
class SetExpressionBuilder : ISqlBuilder {

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
    
    protected auto buildBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildSign($parsed) {
        auto myBuilder = new SignBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $delim = ' ';
            $len = strlen(mySql);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildBracketExpression($v);
                        
            // we don't need whitespace between the sign and 
            // the following part
            if (this.buildSign($v) != '') {
                $delim = "";
            }
            mySql  ~= this.buildSign($v);
            
            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('SET expression subtree', $k, $v, 'expr_type');
            }

            mySql  ~= $delim;
        }
        mySql = substr(mySql, 0, -1);
        return mySql;
    }
}
