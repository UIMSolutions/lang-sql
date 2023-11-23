module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the column entries of the column-list parts of CREATE TABLE.
 * This class : the builder for index column entries of the column-list 
 * parts of CREATE TABLE. 
 *  */
class IndexColumnBuilder : ISqlBuilder {

    protected auto buildLength(Json parsedSql) {
        return (parsedSql.isEmpty ? "" : ("(" ~ parsedSql ~ ")"));
    }

    protected auto buildDirection(Json parsedSql) {
        return (parsedSql.isEmpty ? "" : (" " ~ parsedSql));
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(INDEX_COLUMN) {
            return "";
        }

        string mySql = parsedSql["name"];
        mySql ~= this.buildLength(parsedSql["length"]);
        mySql ~= this.buildDirection(parsedSql["dir"]);
        return mySql;
    }

}
