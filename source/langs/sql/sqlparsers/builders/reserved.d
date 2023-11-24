module langs.sql.sqlparsers.builders.reserved;

import lang.sql;

@safe:

/**
 * Builds reserved keywords. 
 * This class : the builder for reserved keywords.
 */
class ReservedBuilder : ISqlBuilder {

    auto isReserved(Json parsedSql) {
        return ("expr_type" in parsedSql) && parsedSql.isExpressionType("RESERVED");
    }

    string build(Json parsedSql) {
        if (!this.isReserved(parsedSql)) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
