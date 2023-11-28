module lang.sql.parsers.builders;

import lang.sql;

@safe:

// Builds operators.
class OperatorBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("OPERATOR")) {
      return "";
    }
    return parsedSql.baseExpression;
  }
}
