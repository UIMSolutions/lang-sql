module langs.sql.sqlparsers.builders.create.tables.datatype;

import lang.sql;

@safe:

/**
 * Builds the data-type statement part of CREATE TABLE.
 * This class : the builder for the data-type statement part of CREATE TABLE. 
 */
class DataTypeBuilder : IBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("DATA_TYPE")) {
      return "";
    }
    
    return parsedSql["base_expr"];
  }
}
