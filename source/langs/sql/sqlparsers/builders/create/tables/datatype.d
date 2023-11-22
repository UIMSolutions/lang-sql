module langs.sql.sqlparsers.builders.create.tables.datatype;

import lang.sql;

@safe:

/**
 * Builds the data-type statement part of CREATE TABLE.
 * This class : the builder for the data-type statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class DataTypeBuilder : IBuilder {

    string build(Json parsedSql) {
        if (!parsedSql["expr_type"].isExpressionType("DATA_TYPE")) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
