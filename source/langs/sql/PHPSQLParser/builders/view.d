
/**
 * Builds the view within the DROP statement. */

module source.langs.sql.PHPSQLParser.builders.view;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for a view within DROP statement. 
 * You can overwrite all functions to achieve another handling. */
class ViewBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::VIEW) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
