
/**
 * ReservedBuilder.php
 *
 * Builds reserved keywords.
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for reserved keywords.
 * You can overwrite all functions to achieve another handling.
 */
class ReservedBuilder : ISqlBuilder {

    auto isReserved($parsed) {
        return (isset($parsed["expr_type"]) && $parsed["expr_type"] == ExpressionType::RESERVED);
    }

    auto build(array $parsed) {
        if (!this.isReserved($parsed)) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
