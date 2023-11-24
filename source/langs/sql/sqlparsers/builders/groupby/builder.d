module langs.sql.sqlparsers.builders.groupby.builder;

import lang.sql;

@safe:

/**
 * This class : the builder for the GROUP-BY clause. 
 */
class GroupByBuilder : ISqlBuilder {

    protected string buildColRef(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildPosition(Json parsedSql) {
        auto myBuilder = new PositionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildFunction(Json parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildGroupByAlias(Json parsedSql) {
        auto myBuilder = new GroupByAliasBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected string buildGroupByExpression(Json parsedSql) {
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
