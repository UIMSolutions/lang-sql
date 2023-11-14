
/**
 * GroupByBuilder.php
 *
 * Builds the GROUP-BY clause.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling.
 */
class GroupByBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildPosition($parsed) {
        auto myBuilder = new PositionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildGroupByAlias($parsed) {
        auto myBuilder = new GroupByAliasBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildGroupByExpression($parsed) {
    	auto myBuilder = new GroupByExpressionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            $len = mySql.length;
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildPosition($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildGroupByExpression($v);
            mySql  ~= this.buildGroupByAlias($v);
            
            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('GROUP', $k, $v, 'expr_type');
            }

            mySql  ~= ", ";
        }
        mySql = substr(mySql, 0, -2);
        return "GROUP BY " . mySql;
    }

}
