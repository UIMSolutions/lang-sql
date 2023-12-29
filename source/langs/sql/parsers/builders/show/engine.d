module langs.sql.sqlparsers.builders.show.engine;

import langs.sql;

@safe:

// Builds the database within the SHOW statement. 
class EngineBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("ENGINE")) {
      return "";
    }

    return parsedSql.baseExpression;
  }
}
