module langs.sql.sqlparsers.builders.drop.indextable;

import lang.sql;

@safe:

/**
 * This class : the builder for the table part of a DROP INDEX statement.
 * You can overwrite all functions to achieve another handling. */
class DropIndexTableBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if ("on" !in parsedSql || parsedSql["on"] == false) {
            return "";
        }
        auto myTable = parsedSql["on"];
        if (myTable["expr_type"] !.isExpressionType(TABLE) {
            return "";
        }
        return "ON " ~ myTable["name"];
    }

}
