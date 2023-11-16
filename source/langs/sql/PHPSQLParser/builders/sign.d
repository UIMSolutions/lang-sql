module langs.sql.PHPSQLParser.builders.sign;

import lang.sql;

@safe:

/**
 * Builds unary operators. 
 * This class : the builder for unary operators. 
 * You can overwrite all functions to achieve another handling. */
class SignBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ($parsed["expr_type"] !.isExpressionType(SIGN) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
