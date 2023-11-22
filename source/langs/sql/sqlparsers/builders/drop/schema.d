module langs.sql.sqlparsers.builders.drop.schema;

import lang.sql;

@safe:

/**
 * Builds the schema within the DROP statement. 
 * This class : the builder for a schema within DROP statement. 
 * You can overwrite all functions to achieve another handling. */
class SchemaBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql["expr_type"].isExpressionType("SCHEMA")) {
      return "";
    }

    return parsedSql["base_expr"];
  }
}
