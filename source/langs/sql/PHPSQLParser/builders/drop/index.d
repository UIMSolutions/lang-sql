
module langs.sql.PHPSQLParser.builders.drop.index;

import lang.sql;

@safe:
/**
 * This class : the builder for the DROP INDEX statement. You can overwrite
 * all functions to achieve another handling. */
class DropIndexBuilder : IBuilder {

	protected auto buildIndexTable($parsed) {
		auto myBuilder = new DropIndexTableBuilder();
		return myBuilder.build($parsed);
	}

    string build(array $parsed) {
        string mySql = $parsed["name"];
	    mySql = mySql.strip;
	    mySql  ~= " " ~ this.buildIndexTable($parsed);
        return mySql.strip;
    }
}
