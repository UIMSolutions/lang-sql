module langs.sql.sqlparsers.builders.create.tables.selectoptions;

import lang.sql;

@safe:
/**
 * Builds the select-options statement part of CREATE TABLE. 
 * This class : the builder for the select-options statement part of CREATE TABLE. 
 *  */
class CreateTableSelectOptionBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isSet("select-option") || parsedSql["select-option"] == false) {
            return "";
        }

        auto selectOption = parsedSql["select-option"];

        string mySql = (selectOption["duplicates"] == false ? "" : (" " ~ selectOption["duplicates"]));
        mySql ~= (selectOption["as"] == false ? "" : " AS");
        return mySql;
    }
}
