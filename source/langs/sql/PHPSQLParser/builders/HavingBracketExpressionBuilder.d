
/**
 * HavingBracketExpressionBuilder.php
 *
 * Builds bracket expressions within the HAVING part.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for bracket expressions within the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *
 * @author  Ian Barker <ian@theorganicagency.com>
 
 
 *   */
class HavingBracketExpressionBuilder : WhereBracketExpressionBuilder {
    
    protected auto buildHavingExpression($parsed) {
        auto myBuilder = new HavingExpressionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::BRACKET_EXPRESSION) {
            return "";
        }
        
        auto mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildInList(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildHavingExpression(myValue);
            mySql  ~= this.build(myValue);
            mySql  ~= this.buildUserVariable(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('HAVING expression subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = "(" ~ substr(mySql, 0, -1) ~ ")";
        return mySql;
    }

}
