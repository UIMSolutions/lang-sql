
/**
 * PositionBuilder.php
 *
 * Builds positions of the GROUP BY clause. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for positions of the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class OrderByPositionBuilder : ISqlBuilder {
    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::POSITION) {
            return "";
        }
        return $parsed["base_expr"] . this.buildDirection($parsed);
    }
}
