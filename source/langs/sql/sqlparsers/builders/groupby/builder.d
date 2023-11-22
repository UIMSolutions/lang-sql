module langs.sql.sqlparsers.builders.groupby.builder;

import lang.sql;

@safe:

/**
 * This class : the builder for the GROUP-BY clause. 
 *  */
class GroupByBuilder : ISqlBuilder {

    protected auto buildColRef(parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildPosition(parsedSql) {
        auto myBuilder = new PositionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildFunction(parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildGroupByAlias(parsedSql) {
        auto myBuilder = new GroupByAliasBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildGroupByExpression(parsedSql) {
    	auto myBuilder = new GroupByExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = "";
        foreach (myKey, myValue; parsedSql) {
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
