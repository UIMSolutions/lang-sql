
/**
 * SchemaBuilder.php
 *
 * Builds the schema within the DROP statement. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for a schema within DROP statement. 
 * You can overwrite all functions to achieve another handling. */
class SchemaBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::SCHEMA) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
