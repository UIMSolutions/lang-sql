module langs.sql.sqlparsers.builders.orderby.builder;

import lang.sql;

@safe:

/**
 * Builds the ORDERBY clause. */
 * This class : the builder for the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class OrderByBuilder : ISqlBuilder {

    protected auto buildFunction(parsedSql) {
        auto myBuilder = new OrderByFunctionBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildReserved(parsedSql) {
        auto myBuilder = new OrderByReservedBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildColRef(parsedSql) {
        auto myBuilder = new OrderByColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildAlias(parsedSql) {
        auto myBuilder = new OrderByAliasBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildExpression(parsedSql) {
        auto myBuilder = new OrderByExpressionBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildBracketExpression(parsedSql) {
        auto myBuilder = new OrderByBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildPosition(parsedSql) {
        auto myBuilder = new OrderByPositionBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = "";
        foreach (myKey, myValue; parsedSql) {
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
