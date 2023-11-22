module langs.sql.sqlparsers.builders.orderby.builder;

import lang.sql;

@safe:

/**
 * Builds the ORDERBY clause. */
 * This class : the builder for the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class OrderByBuilder : ISqlBuilder {

    protected auto buildFunction(parsedSQL) {
        auto myBuilder = new OrderByFunctionBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new OrderByReservedBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildColRef(parsedSQL) {
        auto myBuilder = new OrderByColumnReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildAlias(parsedSQL) {
        auto myBuilder = new OrderByAliasBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildExpression(parsedSQL) {
        auto myBuilder = new OrderByExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildBracketExpression(parsedSQL) {
        auto myBuilder = new OrderByBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildPosition(parsedSQL) {
        auto myBuilder = new OrderByPositionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = "";
        foreach (myKey, myValue; parsedSQL) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildAlias(myValue);
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildExpression(myValue);
            mySql ~= this.buildBracketExpression(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildPosition(myValue);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("ORDER", myKey, myValue, "expr_type");
            }

            mySql ~= ", ";
        }
        mySql = substr(mySql, 0, -2);

        return "ORDER BY " ~ mySql;
    }
}
