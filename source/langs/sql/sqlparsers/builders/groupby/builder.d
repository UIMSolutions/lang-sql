module langs.sql.sqlparsers.builders.groupby.builder;

import lang.sql;

@safe:

/**
 * This class : the builder for the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling. */
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

    string build(Json parsedSQL) {
        string mySql = "";
        foreach (myKey, myValue; $parsed) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildPosition(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildGroupByExpression(myValue);
            mySql ~= this.buildGroupByAlias(myValue);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("GROUP", myKey, myValue, "expr_type");
            }

            mySql ~= ", ";
        }
        mySql = substr(mySql, 0, -2);
        return "GROUP BY " ~ mySql;
    }

}
