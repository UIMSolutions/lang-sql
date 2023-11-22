module langs.sql.sqlparsers.builders.create.index;

import lang.sql;

@safe:
/**
 * Builds the CREATE INDEX statement
 * This class : the builder for the CREATE INDEX statement. You can overwrite
 * all functions to achieve another handling. */
class CreateIndexBuilder : ISqlBuilder {

    protected auto buildIndexType($parsed) {
        auto myBuilder = new CreateIndexTypeBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildIndexTable($parsed) {
        auto myBuilder = new CreateIndexTableBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildIndexOptions($parsed) {
        auto myBuilder = new CreateIndexOptionsBuilder();
        return myBuilder.build($parsed);
    }

    string build(Json parsedSQL) {
        string mySql = $parsed["name"];
        mySql ~= " " ~ this.buildIndexType($parsed);
        mySql = mySql.strip;
        mySql ~= " " ~ this.buildIndexTable($parsed);
        mySql = mySql.strip;
        mySql ~= this.buildIndexOptions($parsed);
        return mySql.strip;
    }

}
