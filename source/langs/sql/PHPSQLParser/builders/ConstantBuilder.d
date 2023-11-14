
/**
 * ConstantBuilder.php
 *
 * Builds constant (String, Integer, etc.) parts.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for constants. 
 * You can overwrite all functions to achieve another handling.
 */
class ConstantBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CONSTANT) {
            return "";
        }
        
        auto mySql = $parsed["base_expr"];
        mySql  ~= this.buildAlias($parsed);
        return mySql;
    }
}
