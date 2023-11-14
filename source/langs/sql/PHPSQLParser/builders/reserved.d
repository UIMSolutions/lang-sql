
/**
 * ReservedBuilder.php
 *
 * Builds reserved keywords. */

module source.langs.sql.PHPSQLParser.builders.reserved;

import lang.sql;

@safe:

/**
 * This class : the builder for reserved keywords.
 * You can overwrite all functions to achieve another handling. */
class ReservedBuilder : ISqlBuilder {

    auto isReserved($parsed) {
        return (isset($parsed["expr_type"]) && $parsed["expr_type"] == ExpressionType::RESERVED);
    }

    string build(array $parsed) {
        if (!this.isReserved($parsed)) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
