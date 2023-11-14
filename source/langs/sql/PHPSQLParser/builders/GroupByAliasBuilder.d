
/**
 * GroupByAliasBuilder.php
 *
 * Builds an alias within a GROUP-BY clause.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for an alias within the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling.
 */
class GroupByAliasBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::ALIAS) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
