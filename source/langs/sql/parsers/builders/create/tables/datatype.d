module langs.sql.parsers.builders.create.tables.datatype;

import langs.sql;

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
    
    return parsedSql.baseExpression;
  }
}

unittest {
  auto builder = new DataTypeBuilder;
  assert(builder, "Could not create DataTypeBuilder");
}