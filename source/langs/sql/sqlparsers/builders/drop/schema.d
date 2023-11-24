module langs.sql.sqlparsers.builders.drop.schema;

import lang.sql;

@safe:
// Builds the schema within the DROP statement. 
class SchemaBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("SCHEMA")) {
      return "";
    }

    return parsedSql["base_expr"];
  }
}
