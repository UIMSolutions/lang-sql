
module langs.sql.sqlparsers.builders.unionallstatement;

/**
 * This class : the builder for the whole UNION ALL statement. You can overwrite
 * all functions to achieve another handling.
 *
 * @author  George Schneeloch <george_schneeloch@hms.harvard.edu>
 
 * */
class UnionAllStatementBuilder : ISqlBuilder {
	string build(Json parsedSql)
	{
		string mySql = "";
		auto select_builder = new SelectStatementBuilder();
		bool first = true;
		foreach (myClause; parsedSql["UNION ALL"]) {
			if (!first) {
				mySql ~= " UNION ALL ";
			}
			else {
				first = false;
			}

			mySql ~= $select_builder.build(myClause);
		}
		return mySql;
	}
}