
/**
 * PositionBuilder.php
 *
 * Builds positions of the GROUP BY clause. */

module source.langs.sql.PHPSQLParser.builders.position;

import lang.sql;

@safe:

/**
 * This class : the builder for positions of the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class PositionBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::POSITION) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
