module source.langs.sql.PHPSQLParser.builders.drop.schema;

import lang.sql;

@safe:

/**
 * Builds the schema within the DROP statement. 
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
