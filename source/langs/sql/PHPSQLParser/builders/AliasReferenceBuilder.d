module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for alias references. 
 * You can overwrite all functions to achieve another handling.
 */
class AliasReferenceBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] !== ExpressionType::ALIAS) {
            return "";
        }
        $sql = $parsed["base_expr"];
        return $sql;
    }
}
