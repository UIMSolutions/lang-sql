module langs.sql.parsers.builders;

import langs.sql;

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
