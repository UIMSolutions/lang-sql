
/**
 * OperatorBuilder.php
 *
 * Builds operators. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for operators. 
 * You can overwrite all functions to achieve another handling. */
class OperatorBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::OPERATOR) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
