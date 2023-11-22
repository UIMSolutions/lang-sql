module langs.sql.sqlparsers.builders.groupby.builder;

import lang.sql;

@safe:

/**
 * This class : the builder for the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class GroupByBuilder : ISqlBuilder {

    protected auto buildColRef(parsedSQL) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildPosition(parsedSQL) {
        auto myBuilder = new PositionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildFunction(parsedSQL) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildGroupByAlias(parsedSQL) {
        auto myBuilder = new GroupByAliasBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildGroupByExpression(parsedSQL) {
    	auto myBuilder = new GroupByExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = "";
        foreach (myKey, myValue; parsedSQL) {
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
