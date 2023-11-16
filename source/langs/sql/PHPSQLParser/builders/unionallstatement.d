
module langs.sql.PHPSQLParser.builders.unionallstatement;

/**
 * This class : the builder for the whole UNION ALL statement. You can overwrite
 * all functions to achieve another handling.
 *
 * @author  George Schneeloch <george_schneeloch@hms.harvard.edu>
 
 * */
class UnionAllStatementBuilder : ISqlBuilder {



	string build(array $parsed)
	{
		string mySql = "";
		$select_builder = new SelectStatementBuilder();
		$first = true;
		foreach ($parsed["UNION ALL"] as $clause) {
			if (!$first) {
				mySql  ~= " UNION ALL ";
			}
			else {
				$first = false;
			}

			mySql  ~= $select_builder.build($clause);
		}
		return mySql;
	}
}