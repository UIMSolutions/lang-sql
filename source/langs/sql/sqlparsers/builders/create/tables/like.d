module langs.sql.PHPSQLParser.builders.create.tables.like;

import lang.sql;

@safe:

/**
 * Builds the LIKE statement part of a CREATE TABLE statement.
 * This class : the builder for the LIKE statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class LikeBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $index) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, $index);
    }

    string build(array $parsed) {
        string mySql = this.buildTable($parsed, 0);
        if (mySql.isEmpty) {
            throw new UnableToCreateSQLException('LIKE', "", $parsed, 'table');
        }
        return "LIKE " ~ mySql;
    }
}