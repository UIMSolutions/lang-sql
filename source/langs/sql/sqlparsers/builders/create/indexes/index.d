module langs.sql.sqlparsers.builders.create.index;

import lang.sql;

@safe:
/**
 * Builds the CREATE INDEX statement
 * This class : the builder for the CREATE INDEX statement. You can overwrite
 * all functions to achieve another handling. */
class CreateIndexBuilder : ISqlBuilder {

    protected auto buildIndexType(Json parsedSql) {
        auto myBuilder = new CreateIndexTypeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildIndexTable(Json parsedSql) {
        auto myBuilder = new CreateIndexTableBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildIndexOptions(Json parsedSql) {
        auto myBuilder = new CreateIndexOptionsBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = parsedSql["name"];
        mySql ~= " " ~ this.buildIndexType(parsedSql);
        mySql = mySql.strip;
        mySql ~= " " ~ this.buildIndexTable(parsedSql);
        mySql = mySql.strip;
        mySql ~= this.buildIndexOptions(parsedSql);
        return mySql.strip;
    }

}
