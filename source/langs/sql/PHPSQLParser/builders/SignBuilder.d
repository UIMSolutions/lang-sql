
/**
 * SignBuilder.php
 *
 * Builds unary operators.

 * 
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for unary operators. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class SignBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::SIGN) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
