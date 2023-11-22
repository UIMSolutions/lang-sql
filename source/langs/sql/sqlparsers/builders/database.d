module langs.sql.sqlparsers.builders.database;

import lang.sql;

@safe:

/**
 * Builds the database within the SHOW statement.
 * This class : the builder for a database within SHOW statement. 
 *  */
class DatabaseBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(DATABASE) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
