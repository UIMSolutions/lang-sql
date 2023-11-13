
/**
 * FunctionBuilder.php
 *
 * Builds auto statements.
 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for auto calls. 
 * You can overwrite all functions to achieve another handling.  
 */
class FunctionBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        $builder = new AliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto isReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.isReserved($parsed);
    }
    
    protected auto buildSelectExpression($parsed) {
        $builder = new SelectExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectBracketExpression($parsed) {
        $builder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildSubQuery($parsed) {
        $builder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariableExpression($parsed) {
        $builder = new UserVariableBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if (($parsed["expr_type"] != ExpressionType::AGGREGATE_FUNCTION)
            && ($parsed["expr_type"] != ExpressionType::SIMPLE_FUNCTION)
            && ($parsed["expr_type"] != ExpressionType::CUSTOM_FUNCTION)) {
            return "";
        }

        if ($parsed["sub_tree"] == false) {
            return $parsed["base_expr"] . "()" . this.buildAlias($parsed);
        }

        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.build($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildSelectBracketExpression($v);
            mySql  ~= this.buildSelectExpression($v);
            mySql  ~= this.buildUserVariableExpression($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('auto subtree', $k, $v, 'expr_type');
            }

            mySql  ~= (this.isReserved($v) ? " " : ",");
        }
        return $parsed["base_expr"] . "(" . substr(mySql, 0, -1) . ")" . this.buildAlias($parsed);
    }

}
