
module langs.sql.sqlparsers.builders.unionallstatement;

/**
 * This class : the builder for the whole UNION ALL statement. You can overwrite
 * all functions to achieve another handling.
 *
 * @author  George Schneeloch <george_schneeloch@hms.harvard.edu>
 
 * */
class UnionAllStatementBuilder : ISqlBuilder {



	string build(Json parsedSQL)
	{
		string mySql = "";
		$select_builder = new SelectStatementBuilder();
		$first = true;
		foreach (parsedSQL["UNION ALL"] as $clause) {
			if (!$first) {
				mySql ~= " UNION ALL ";
			}
			else {
				$first = false;
			}

			mySql ~= $select_builder.build($clause);
		}
		return mySql;
	}
}