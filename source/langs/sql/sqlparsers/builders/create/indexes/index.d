module langs.sql.sqlparsers.builders.create.index;

import lang.sql;

@safe:
/**
 * Builds the CREATE INDEX statement
 * This class : the builder for the CREATE INDEX statement. You can overwrite
 * all functions to achieve another handling. */
class CreateIndexBuilder : ISqlBuilder {

    protected auto buildIndexType(parsedSQL) {
        auto myBuilder = new CreateIndexTypeBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildIndexTable(parsedSQL) {
        auto myBuilder = new CreateIndexTableBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildIndexOptions(parsedSQL) {
        auto myBuilder = new CreateIndexOptionsBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = parsedSQL["name"];
        mySql ~= " " ~ this.buildIndexType(parsedSQL);
        mySql = mySql.strip;
        mySql ~= " " ~ this.buildIndexTable(parsedSQL);
        mySql = mySql.strip;
        mySql ~= this.buildIndexOptions(parsedSQL);
        return mySql.strip;
    }

}
