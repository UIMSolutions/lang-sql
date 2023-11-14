module langs.sql.PHPSQLParser.builders.database;

import lang.sql;

@safe:

/**
 * Builds the database within the SHOW statement.
 * This class : the builder for a database within SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class DatabaseBuilder : ISqlBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::DATABASE) {
            return "";
        }
        return $parsed["base_expr"];
    }
}
