
/**
 * HavingExpressionBuilder.php
 *
 * Builds expressions within the HAVING part.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for expressions within the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *
 * @author  Ian Barker <ian@theorganicagency.com>
 
 
 *  
 */
class HavingExpressionBuilder : WhereExpressionBuilder {

    protected auto buildHavingExpression($parsed) {
        return this.build($parsed);
    }

    protected auto buildHavingBracketExpression($parsed) {
        auto myBuilder = new HavingBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildInList($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildHavingExpression($v);
            mySql  ~= this.buildHavingBracketExpression($v);
            mySql  ~= this.buildUserVariable($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('HAVING expression subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }

}
