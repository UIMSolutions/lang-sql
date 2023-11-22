module langs.sql.sqlparsers.builders.show.engine;

import lang.sql;

@safe:

/**
 * Builds the database within the SHOW statement. 
 * This class : the builder for a database within SHOW statement. 
 * You can overwrite all functions to achieve another handling */
class EngineBuilder : ISqlBuilder {

  auto build(Json parsedSQL) {
    if ($parsed["expr_type"] !.isExpressionType(ENGINE) {
      return "";
    }

    return $parsed["base_expr"];
  }
}
