module langs.sql.sqlparsers.builders.sign;

import langs.sql;

@safe:

// Builds unary operators. 
class SignBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("SIGN")) {
      return null;
    }
    return parsedSql.baseExpression;
  }
}
