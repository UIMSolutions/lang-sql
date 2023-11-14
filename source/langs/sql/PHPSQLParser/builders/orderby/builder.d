
/**
 * OrderByBuilder.php
 *
 * Builds the ORDERBY clause. */

module source.langs.sql.PHPSQLParser.builders.orderby.builder;

import lang.sql;

@safe:

/**
 * This class : the builder for the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class OrderByBuilder : ISqlBuilder {

    protected auto buildFunction($parsed) {
        auto myBuilder = new OrderByFunctionBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildReserved($parsed) {
        auto myBuilder = new OrderByReservedBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildColRef($parsed) {
        auto myBuilder = new OrderByColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        auto myBuilder = new OrderByAliasBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildExpression($parsed) {
        auto myBuilder = new OrderByExpressionBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildBracketExpression($parsed) {
        auto myBuilder = new OrderByBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildPosition($parsed) {
        auto myBuilder = new OrderByPositionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildAlias($v);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildExpression($v);
            mySql  ~= this.buildBracketExpression($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildPosition($v);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('ORDER', $k, $v, 'expr_type');
            }

            mySql  ~= ", ";
        }
        mySql = substr(mySql, 0, -2);
        return "ORDER BY " . mySql;
    }
}
