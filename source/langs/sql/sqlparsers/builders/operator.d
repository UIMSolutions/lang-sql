module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds operators.
 * This class : the builder for operators. 
 * You can overwrite all functions to achieve another handling. */
class OperatorBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ($parsed["expr_type"] !.isExpressionType(OPERATOR) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
