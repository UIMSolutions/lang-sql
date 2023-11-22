module langs.sql.sqlparsers.builders.reserved;

import lang.sql;

@safe:

/**
 * Builds reserved keywords. 
 * This class : the builder for reserved keywords.
 * You can overwrite all functions to achieve another handling. */
class ReservedBuilder : ISqlBuilder {

    auto isReserved(parsedSql) {
        return ("expr_type" in parsedSql) && parsedSql["expr_type"].isExpressionType("RESERVED");
    }

    string build(Json parsedSql) {
        if (!this.isReserved(parsedSql)) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
