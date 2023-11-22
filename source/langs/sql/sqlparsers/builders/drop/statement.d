module langs.sql.sqlparsers.builders.drop.statement;

import lang.sql;

@safe:
/**
 * Builds the DROP statement
 * This class : the builder for the whole DROP TABLE statement. 
 * You can overwrite all functions to achieve another handling. */
class DropStatementBuilder : IBuilder {

	protected auto buildDROP( parsedSQL ) {
		auto myBuilder = new DropBuilder();
		return myBuilder.build( parsedSQL );
	}

	auto build( Json parsedSQL ) {
		return this.buildDROP( parsedSQL );
	}
}
