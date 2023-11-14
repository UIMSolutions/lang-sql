
/**
 * ConstantBuilder.php
 *
 * Builds constant (String, Integer, etc.) parts.
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for constants. 
 * You can overwrite all functions to achieve another handling.
 */
class ConstantBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CONSTANT) {
            return "";
        }
        $sql = $parsed["base_expr"];
        $sql  ~= this.buildAlias($parsed);
        return $sql;
    }
}
