
/**
 * DefaultValueBuilder.php
 *
 * Builds the default value statement part of a column of a CREATE TABLE. */

module source.langs.sql.PHPSQLParser.builders.defaulvalue;

import lang.sql;

@safe:

/**
 * This class : the builder for the default value statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class DefaultValueBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::DEF_VALUE) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
