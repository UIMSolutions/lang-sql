
/**
 * SetExpressionBuilder.php
 *
 * Builds the SET part of the INSERT statement.

 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class SetExpressionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildOperator($parsed) {
        $builder = new OperatorBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildFunction($parsed) {
        $builder = new FunctionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildBracketExpression($parsed) {
        $builder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildSign($parsed) {
        $builder = new SignBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $delim = ' ';
            $len = strlen($sql);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildBracketExpression($v);
                        
            // we don't need whitespace between the sign and 
            // the following part
            if (this.buildSign($v) != '') {
                $delim = "";
            }
            $sql  ~= this.buildSign($v);
            
            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('SET expression subtree', $k, $v, 'expr_type');
            }

            $sql  ~= $delim;
        }
        $sql = substr($sql, 0, -1);
        return $sql;
    }
}
