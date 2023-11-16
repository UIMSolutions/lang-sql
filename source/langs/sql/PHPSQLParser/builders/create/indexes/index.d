
/**
 * CreateIndex.php
 *
 * Builds the CREATE INDEX statement
 * */

module langs.sql.PHPSQLParser.builders.create.index;

import lang.sql;

@safe:
/**
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

    string build(array $parsed) {
        string mySql = $parsed["name"];
        mySql  ~= " " ~ this.buildIndexType($parsed);
        mySql = trim(mySql);
        mySql  ~= " " ~ this.buildIndexTable($parsed);
        mySql = trim(mySql);
        mySql  ~= this.buildIndexOptions($parsed);
        return trim(mySql);
    }

}
