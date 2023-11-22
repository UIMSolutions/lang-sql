
module langs.sql.sqlparsers.builders.havingexpression;

import lang.sql;

@safe:

/**
 * Builds expressions within the HAVING part.
 * This class : the builder for expressions within the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *   */
class HavingExpressionBuilder : WhereExpressionBuilder {

    protected auto buildHavingExpression($parsed) {
        return this.build($parsed);
    }

    protected auto buildHavingBracketExpression($parsed) {
        auto myBuilder = new HavingBracketExpressionBuilder();
        return myBuilderr.build($parsed);
    }

    string build(auto[string] parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(EXPRESSION) {
            return "";
        }
        
        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildInList(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildHavingExpression(myValue);
            mySql ~= this.buildHavingBracketExpression(myValue);
            mySql ~= this.buildUserVariable(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("HAVING expression subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }

}
