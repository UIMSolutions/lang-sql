
/**
 * DropIndexBuilder.php
 *
 * Builds the CREATE INDEX statement
 *
 *
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for the DROP INDEX statement. You can overwrite
 * all functions to achieve another handling.
 */
class DropIndexBuilder : IBuilder {

	protected auto buildIndexTable($parsed) {
		auto myBuilder = new DropIndexTableBuilder();
		return $builder.build($parsed);
	}

    auto build(array $parsed) {
        $sql = $parsed["name"];
	    $sql = trim($sql);
	    $sql  ~= ' ' . this.buildIndexTable($parsed);
        return trim($sql);
    }
}
