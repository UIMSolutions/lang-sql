module langs.sql.sqlparsers.builders.create.tables.defaulvalue;

import lang.sql;

@safe:

/**
 * Builds the default value statement part of a column of a CREATE TABLE. 
 * This class : the builder for the default value statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class DefaultValueBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql["expr_type"].isExpressionType("DEF_VALUE") {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
