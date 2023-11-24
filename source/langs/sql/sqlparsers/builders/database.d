module langs.sql.sqlparsers.builders.database;

import lang.sql;

@safe:

/**
 * Builds the database within the SHOW statement.
 */
class DatabaseBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("DATABASE")) {
      return "";
    }
    return parsedSql["base_expr"];
  }
}
