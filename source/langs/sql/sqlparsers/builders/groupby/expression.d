module langs.sql.sqlparsers.builders.groupby.expression;

import lang.sql;

@safe:

/**
 * Builds an expression within a GROUP-BY clause.
 * This class : the builder for an alias within the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling.
 *   */
class GroupByExpressionBuilder : ISqlBuilder {

	protected auto buildColRef(parsedSQL) {
		auto myBuilder = new ColumnReferenceBuilder();
		return myBuilder.build(parsedSQL);
	}
	
	protected auto buildReserved(parsedSQL) {
		auto myBuilder = new ReservedBuilder();
		return myBuilderr.build(parsedSQL);
	}
	
    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(EXPRESSION) { return ""; }
        
        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
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
