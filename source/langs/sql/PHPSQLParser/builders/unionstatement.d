
module langs.sql.PHPSQLParser.builders.unionstatement;

/**
 * This class : the builder for the whole Union statement. You can overwrite
 * all functions to achieve another handling.
 *
 * @author  George Schneeloch <george_schneeloch@hms.harvard.edu>
 
 * */
class UnionStatementBuilder : ISqlBuilder {

	string build(array $parsed)
	{
		string mySql = "";
		$select_builder = new SelectStatementBuilder();
		$first = true;
		foreach ($parsed["UNION"] as $clause) {
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