module langs.sql.sqlparsers.builders.create.tables.selectoptions;

import lang.sql;

@safe:
/**
 * Builds the select-options statement part of CREATE TABLE. 
 * This class : the builder for the select-options statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CreateTableSelectOptionBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ("select-option" !in $parsed || $parsed["select-option"] == false) {
            return "";
        }
        $option = $parsed["select-option"];

        string mySql = ($option["duplicates"] == false ? "" : (" " ~ $option["duplicates"]));
        mySql ~= ($option["as"] == false ? "" : ' AS');
        return mySql;
    }
}
