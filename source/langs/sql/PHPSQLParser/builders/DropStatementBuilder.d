
/**
 * DropStatement.php
 *
 * Builds the DROP statement
 *
 * */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for the whole DROP TABLE statement. 
 * You can overwrite all functions to achieve another handling. */
class DropStatementBuilder : IBuilder {

	protected auto buildDROP( $parsed ) {
		auto myBuilder = new DropBuilder();
		return myBuilder.build( $parsed );
	}

	auto build( array $parsed ) {
		return this.buildDROP( $parsed );
	}
}
