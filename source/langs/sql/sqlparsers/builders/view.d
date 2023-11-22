
/**
 * Builds the view within the DROP statement. */

module langs.sql.sqlparsers.builders.view;

import lang.sql;

@safe:

/**
 * This class : the builder for a view within DROP statement. 
 * You can overwrite all functions to achieve another handling. */
class ViewBuilder : ISqlBuilder {

    string build(auto[string] parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(VIEW) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
