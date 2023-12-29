module langs.sql.parsers.builders.reserved;

import langs.sql;

@safe:

// Builds reserved keywords. 
class ReservedBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!this.isReserved(parsedSql)) { return ""; }

    return parsedSql.baseExpression;
  }

  auto isReserved(Json parsedSql) {
    return parsedSql.isExpressionType("RESERVED");
  }
}
