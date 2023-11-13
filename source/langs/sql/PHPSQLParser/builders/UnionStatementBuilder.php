
module lang.sql.parsersbuilders;

/**
 * This class : the builder for the whole Union statement. You can overwrite
 * all functions to achieve another handling.
 *
 * @author  George Schneeloch <george_schneeloch@hms.harvard.edu>
 
 *
 */
class UnionStatementBuilder : Builder {

	auto build(array $parsed)
	{
		$sql = '';
		$select_builder = new SelectStatementBuilder();
		$first = true;
		foreach ($parsed['UNION'] as $clause) {
			if (!$first) {
				$sql  ~= " UNION ";
			}
			else {
				$first = false;
			}

			$sql  ~= $select_builder.build($clause);
		}
		return $sql;
	}
}