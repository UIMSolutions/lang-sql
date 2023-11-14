
/**
 * InListBuilder.php
 *
 * Builds lists of values for the IN statement.

 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder list of values for the IN statement. 
 * You can overwrite all functions to achieve another handling.
 */
class InListBuilder : ISqlBuilder {

    protected auto buildSubTree($parsed, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return $builder.build($parsed, $delim);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::IN_LIST) {
            return "";
        }
        $sql = this.buildSubTree($parsed, ", ");
        return "(" . $sql . ")";
    }
}
