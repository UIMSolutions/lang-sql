
/**
 * FunctionBuilder.php
 *
 * Builds auto statements. * 
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
        myBuilder = new AliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto isReserved($parsed) {
        myBuilder = new ReservedBuilder();
        return $builder.isReserved($parsed);
    }
    
    protected auto buildSelectExpression($parsed) {
        myBuilder = new SelectExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectBracketExpression($parsed) {
        myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildSubQuery($parsed) {
        myBuilder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariableExpression($parsed) {
        myBuilder = new UserVariableBuilder();
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
