module langs.sql.sqlparsers.builders.show.engine;

import lang.sql;

@safe:

/**
 * Builds the database within the SHOW statement. 
 * This class : the builder for a database within SHOW statement. 
 * You can overwrite all functions to achieve another handling */
class EngineBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType(ENGINE) {
      return "";
    }

    return parsedSql["base_expr"];
  }
}
