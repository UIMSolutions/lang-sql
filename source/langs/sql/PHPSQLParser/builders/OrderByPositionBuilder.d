
/**
 * PositionBuilder.php
 *
 * Builds positions of the GROUP BY clause.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for positions of the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class OrderByPositionBuilder : ISqlBuilder {
    protected auto buildDirection($parsed) {
        $builder = new DirectionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::POSITION) {
            return "";
        }
        return $parsed["base_expr"] . this.buildDirection($parsed);
    }
}
