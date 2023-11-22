module langs.sql.sqlparsers.builders.position;

import lang.sql;

@safe:

/**
 * Builds positions of the GROUP BY clause. 
 * This class : the builder for positions of the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class PositionBuilder : ISqlBuilder {

    string build(auto[string] parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(POSITION) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
