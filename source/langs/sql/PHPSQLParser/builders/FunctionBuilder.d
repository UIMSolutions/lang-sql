
/**
 * FunctionBuilder.php
 *
 * Builds auto statements. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for auto calls. 
 * You can overwrite all functions to achieve another handling.  
 */
class FunctionBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto isReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilderr.isReserved($parsed);
    }
    
    protected auto buildSelectExpression($parsed) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSelectBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildUserVariableExpression($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build($parsed);
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

        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.build($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildSelectBracketExpression($v);
            mySql  ~= this.buildSelectExpression($v);
            mySql  ~= this.buildUserVariableExpression($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('auto subtree', $k, $v, 'expr_type');
            }

            mySql  ~= (this.isReserved($v) ? " " : ",");
        }
        return $parsed["base_expr"] . "(" . substr(mySql, 0, -1) . ")" . this.buildAlias($parsed);
    }

}
