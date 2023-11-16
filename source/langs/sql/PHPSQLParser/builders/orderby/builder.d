module langs.sql.PHPSQLParser.builders.orderby.builder;

import lang.sql;

@safe:

/**
 * Builds the ORDERBY clause. */
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

    string build(array $parsed) {
        string mySql = "";
        foreach (myKey, myValue; $parsed) {
            size_t oldSqlLength = mySql.length;
            mySql  ~= this.buildAlias(myValue);
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildExpression(myValue);
            mySql  ~= this.buildBracketExpression(myValue);
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildPosition(myValue);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('ORDER', myKey, myValue, "expr_type");
            }

            mySql  ~= ", ";
        }
        mySql = substr(mySql, 0, -2);
        
        return "ORDER BY " ~ mySql;
    }
}
