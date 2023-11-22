
module langs.sql.sqlparsers.builders.drop.index;

import lang.sql;

@safe:
/**
 * This class : the builder for the DROP INDEX statement. You can overwrite
 * all functions to achieve another handling. */
class DropIndexBuilder : IBuilder {

	protected auto buildIndexTable(parsedSQL) {
		auto myBuilder = new DropIndexTableBuilder();
		return myBuilder.build(parsedSQL);
	}

    string build(Json parsedSQL) {
        string mySql = parsedSQL["name"];
	    mySql = mySql.strip;
	    mySql ~= " " ~ this.buildIndexTable(parsedSQL);
        return mySql.strip;
    }
}
