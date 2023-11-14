module source.langs.sql.PHPSQLParser.builders.drop.statement;

import lang.sql;

@safe:
/**
 * Builds the DROP statement
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
