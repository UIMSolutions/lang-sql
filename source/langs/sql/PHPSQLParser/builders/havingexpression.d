
/**
 * HavingExpressionBuilder.php
 *
 * Builds expressions within the HAVING part.
 */

module source.langs.sql.PHPSQLParser.builders.havingexpression;

import lang.sql;

@safe:

/**
 * This class : the builder for expressions within the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *
 * @author  Ian Barker <ian@theorganicagency.com>
 
 
 *   */
class HavingExpressionBuilder : WhereExpressionBuilder {

    protected auto buildHavingExpression($parsed) {
        return this.build($parsed);
    }

    protected auto buildHavingBracketExpression($parsed) {
        auto myBuilder = new HavingBracketExpressionBuilder();
        return myBuilderr.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
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
            mySql  ~= this.buildHavingBracketExpression(myValue);
            mySql  ~= this.buildUserVariable(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('HAVING expression subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }

}
