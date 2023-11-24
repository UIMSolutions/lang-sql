module langs.sql.sqlparsers.builders.drop.statement;

import lang.sql;

@safe:
/**
 * Builds the DROP statement
 * This class : the builder for the whole DROP TABLE statement. 
 */
class DropStatementBuilder : IBuilder {

	protected string buildDROP( parsedSql ) {
		auto myBuilder = new DropBuilder();
		return myBuilder.build( parsedSql );
	}

	string build( Json parsedSql ) {
		return this.buildDROP( parsedSql );
	}
}
