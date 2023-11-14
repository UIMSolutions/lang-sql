
/**
 * SelectExpressionBuilder.php
 *
 * Builds simple expressions within a SELECT statement.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for simple expressions within a SELECT statement. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class SelectExpressionBuilder : ISqlBuilder {

    protected auto buildSubTree($parsed, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return $builder.build($parsed, $delim);
    }

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        $sql = this.buildSubTree($parsed, " ");
        $sql  ~= this.buildAlias($parsed);
        return $sql;
    }
}
