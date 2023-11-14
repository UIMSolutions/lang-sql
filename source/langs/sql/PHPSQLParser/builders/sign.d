
/**
 * SignBuilder.php
 *
 * Builds unary operators. */

module source.langs.sql.PHPSQLParser.builders.sign;

import lang.sql;

@safe:

/**
 * This class : the builder for unary operators. 
 * You can overwrite all functions to achieve another handling. */
class SignBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::SIGN) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
