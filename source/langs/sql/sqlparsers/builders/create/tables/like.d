module langs.sql.sqlparsers.builders.create.tables.like;

import lang.sql;

@safe:

/**
 * Builds the LIKE statement part of a CREATE TABLE statement.
 * This class : the builder for the LIKE statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class LikeBuilder : ISqlBuilder {

    protected auto buildTable(parsedSql, $index) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, $index);
    }

    string build(Json parsedSql) {
        string mySql = this.buildTable(parsedSql, 0);
        if (mySql.isEmpty) {
            throw new UnableToCreateSQLException("LIKE", "", parsedSql, "table");
        }
        return "LIKE " ~ mySql;
    }
}
