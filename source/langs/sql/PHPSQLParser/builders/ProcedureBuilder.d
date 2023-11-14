
/**
 * Procedureuilder.php
 *
 * Builds the procedures within the SHOW statement. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for a procedure within SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class ProcedureBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::PROCEDURE) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
