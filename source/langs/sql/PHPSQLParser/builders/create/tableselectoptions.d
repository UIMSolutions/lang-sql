
/**
 * CreateTableSelectOptionBuilder.php
 *
 * Builds the select-options statement part of CREATE TABLE. */
module langs.sql.PHPSQLParser.builders.create.tableselectoptions;

import lang.sql;

@safe:
/**
 * This class : the builder for the select-options statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CreateTableSelectOptionBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if (!isset($parsed["select-option"]) || $parsed["select-option"] == false) {
            return "";
        }
        $option = $parsed["select-option"];

        mySql = ($option["duplicates"] == false ? '' : (" " ~ $option["duplicates"]));
        mySql  ~= ($option["as"] == false ? '' : ' AS');
        return mySql;
    }
}
