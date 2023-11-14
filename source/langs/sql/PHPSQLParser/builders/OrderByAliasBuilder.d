
/**
 * OrderByAliasBuilder.php
 *
 * Builds an alias within an ORDER-BY clause.

 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for an alias within the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class OrderByAliasBuilder : ISqlBuilder {

    protected auto buildDirection($parsed) {
        $builder = new DirectionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::ALIAS) {
            return "";
        }
        return $parsed["base_expr"] . this.buildDirection($parsed);
    }
}
