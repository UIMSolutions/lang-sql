module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the column entries of the column-list parts of CREATE TABLE.
 * This class : the builder for index column entries of the column-list 
 * parts of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class IndexColumnBuilder : ISqlBuilder {

    protected auto buildLength(parsedSQL) {
        return (parsedSQL.isEmpty ? "" : ("(" ~ parsedSQL ~ ")"));
    }

    protected auto buildDirection(parsedSQL) {
        return (parsedSQL.isEmpty ? "" : (" " ~ parsedSQL));
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(INDEX_COLUMN) {
            return "";
        }

        string mySql = parsedSQL["name"];
        mySql ~= this.buildLength(parsedSQL["length"]);
        mySql ~= this.buildDirection(parsedSQL["dir"]);
        return mySql;
    }

}
