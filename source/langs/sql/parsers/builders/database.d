module langs.sql.sqlparsers.builders.database;

import langs.sql;

@safe:

//Builds the database within the SHOW statement.
class DatabaseBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("DATABASE")) {
      return null;
    }
    return parsedSql.baseExpression;
  }
}
