module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the column entries of the column-list parts of CREATE TABLE.
 * This class : the builder for index column entries of the column-list 
 * parts of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class IndexColumnBuilder : ISqlBuilder {

    protected auto buildLength($parsed) {
        return ($parsed.isEmpty ? "" : ("(" ~ $parsed ~ ")"));
    }

    protected auto buildDirection($parsed) {
        return ($parsed.isEmpty ? "" : (" " ~ $parsed));
    }

    string build(auto[string] parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(INDEX_COLUMN) {
            return "";
        }

        string mySql = $parsed["name"];
        mySql ~= this.buildLength($parsed["length"]);
        mySql ~= this.buildDirection($parsed["dir"]);
        return mySql;
    }

}
