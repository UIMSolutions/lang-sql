module langs.sql.sqlparsers.builders.create.index;

import langs.sql;

@safe:
// Builds the CREATE INDEX statement
class CreateIndexBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        string mySql = parsedSql["name"].get!string;
        mySql ~= " " ~ this.buildIndexType(parsedSql);
        mySql = mySql.strip;
        mySql ~= " " ~ this.buildIndexTable(parsedSql);
        mySql = mySql.strip;
        mySql ~= this.buildIndexOptions(parsedSql);
        return mySql.strip;
    }

    protected string buildIndexType(Json parsedSql) {
        auto myBuilder = new CreateIndexTypeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexTable(Json parsedSql) {
        auto myBuilder = new CreateIndexTableBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexOptions(Json parsedSql) {
        auto myBuilder = new CreateIndexOptionsBuilder();
        return myBuilder.build(parsedSql);
    }

}
