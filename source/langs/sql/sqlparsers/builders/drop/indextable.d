module langs.sql.sqlparsers.builders.drop.indextable;

import lang.sql;

@safe:

/**
 * This class : the builder for the table part of a DROP INDEX statement.
 * You can overwrite all functions to achieve another handling. */
class DropIndexTableBuilder : ISqlBuilder {

    string build(Json parsedSQL) {
        if ("on" !in parsedSQL || parsedSQL["on"] == false) {
            return "";
        }
        auto myTable = parsedSQL["on"];
        if (myTable["expr_type"] !.isExpressionType(TABLE) {
            return "";
        }
        return "ON " ~ myTable["name"];
    }

}
