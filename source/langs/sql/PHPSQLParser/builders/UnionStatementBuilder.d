
module lang.sql.parsers.builders;

/**
 * This class : the builder for the whole Union statement. You can overwrite
 * all functions to achieve another handling.
 *
 * @author  George Schneeloch <george_schneeloch@hms.harvard.edu>
 
 *
 */
class UnionStatementBuilder : ISqlBuilder {

	auto build(array $parsed)
	{
		mySql = "";
		$select_builder = new SelectStatementBuilder();
		$first = true;
		foreach ($parsed["UNION"] as $clause) {
			if (!$first) {
				mySql  ~= " UNION ";
			}
			else {
				$first = false;
			}

			mySql  ~= $select_builder.build($clause);
		}
		return mySql;
	}
}