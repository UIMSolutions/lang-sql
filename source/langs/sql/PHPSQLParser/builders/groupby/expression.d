module source.langs.sql.PHPSQLParser.builders.groupby.expression;

import lang.sql;

@safe:

/**
 * Builds an expression within a GROUP-BY clause.
 * This class : the builder for an alias within the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling.
 *   */
class GroupByExpressionBuilder : ISqlBuilder {

	protected auto buildColRef($parsed) {
		auto myBuilder = new ColumnReferenceBuilder();
		return myBuilder.build($parsed);
	}
	
	protected auto buildReserved($parsed) {
		auto myBuilder = new ReservedBuilder();
		return myBuilderr.build($parsed);
	}
	
    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) { return ""; }
        
        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildReserved(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('GROUP expression subtree', $k, myValue, "expr_type");
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }
}
