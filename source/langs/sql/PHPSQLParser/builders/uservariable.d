
/**
 * UserVariableBuilder.php
 *
 * Builds an user variable. */

module langs.sql.PHPSQLParser.builders.uservariable;

import lang.sql;

@safe:

/**
 * This class : the builder for an user variable. 
 * You can overwrite all functions to achieve another handling. */
class UserVariableBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::USER_VARIABLE) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
