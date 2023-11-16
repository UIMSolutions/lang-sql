
/**
 * Builds the view within the DROP statement. */

module langs.sql.PHPSQLParser.builders.view;

import lang.sql;

@safe:

/**
 * This class : the builder for a view within DROP statement. 
 * You can overwrite all functions to achieve another handling. */
class ViewBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ($parsed["expr_type"] !.isExpressionType(VIEW) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
