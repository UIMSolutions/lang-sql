
module langs.sql.sqlparsers.builders.unionstatement;

/**
 * This class : the builder for the whole Union statement. You can overwrite
 * all functions to achieve another handling.
 *

 
 * */
class UnionStatementBuilder : ISqlBuilder {

	string build(Json parsedSql) {
		string mySql = "";
		auto selectBuilder = new SelectStatementBuilder();
		bool first = true;
		foreach ($clause; parsedSql["UNION"]) {
			if (!first) {
				mySql ~= " UNION ";
			}
			else {
				first = false;
			}

			mySql ~= selectBuilder.build($clause);
		}
		return mySql;
	}
}