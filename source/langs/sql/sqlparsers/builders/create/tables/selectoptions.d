module langs.sql.sqlparsers.builders.create.tables.selectoptions;

import lang.sql;

@safe:
/**
 * Builds the select-options statement part of CREATE TABLE. 
 * This class : the builder for the select-options statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CreateTableSelectOptionBuilder : ISqlBuilder {

    string build(Json parsedSQL) {
        if (!parsedSQL.isSet("select-option") || parsedSQL["select-option"] == false) {
            return "";
        }

        auto selectOption = parsedSQL["select-option"];

        string mySql = (selectOption["duplicates"] == false ? "" : (" " ~ selectOption["duplicates"]));
        mySql ~= (selectOption["as"] == false ? "" : " AS");
        return mySql;
    }
}
