
module langs.sql.sqlparsers.builders.unionstatement;

/**
 * This class : the builder for the whole Union statement. You can overwrite
 * all functions to achieve another handling.
 *

 
 * */
class UnionStatementBuilder : ISqlBuilder {

	string build(Json parsedSql) {
		string mySql = "";
		$select_builder = new SelectStatementBuilder();
		$first = true;
		foreach ($clause; parsedSql["UNION"]) {
			if (!$first) {
				mySql ~= " UNION ";
			}
			else {
				$first = false;
			}

			mySql ~= $select_builder.build($clause);
		}
		return mySql;
	}
}