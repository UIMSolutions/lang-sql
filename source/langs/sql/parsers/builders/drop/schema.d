module langs.sql.parsers.builders.drop.schema;

import langs.sql;

@safe:
// Builds the schema within the DROP statement. 
class SchemaBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("SCHEMA")) {
      return null;
    }

    return parsedSql.baseExpression;
  }
}
