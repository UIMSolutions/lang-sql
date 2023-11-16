
/**
 * OrderByAliasBuilder.php
 *
 * Builds an alias within an ORDER-BY clause.
 */

module langs.sql.PHPSQLParser.builders.orderby.alias;

import lang.sql;

@safe:

/**
 * This class : the builder for an alias within the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class OrderByAliasBuilder : ISqlBuilder {

    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] !.isExpressionType(ALIAS) {
            return "";
        }
        return $parsed["base_expr"] . this.buildDirection($parsed);
    }
}
