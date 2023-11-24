module langs.sql.sqlparsers.builders.groupby.expression;

import lang.sql;

@safe:

// Builds an expression within a GROUP-BY clause.
class GroupByExpressionBuilder : ISqlBuilder {

	protected string buildColRef(Json parsedSql) {
		auto myBuilder = new ColumnReferenceBuilder();
		return myBuilder.build(parsedSql);
	}
	
	protected string buildReserved(Json parsedSql) {
		auto myBuilder = new ReservedBuilder();
		return myBuilderr.build(parsedSql);
	}
	
    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("EXPRESSION")) { return ""; }
        
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildReserved(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("GROUP expression subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }
}
