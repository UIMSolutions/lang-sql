module langs.sql.sqlparsers.builders.reserved;

import lang.sql;

@safe:

/**
 * Builds reserved keywords. 
 * This class : the builder for reserved keywords.
 * You can overwrite all functions to achieve another handling. */
class ReservedBuilder : ISqlBuilder {

    auto isReserved(parsedSQL) {
        return ("expr_type" in parsedSQL) && parsedSQL["expr_type"].isExpressionType("RESERVED");
    }

    string build(Json parsedSQL) {
        if (!this.isReserved(parsedSQL)) {
            return "";
        }
        return parsedSQL["base_expr"];
    }
}
