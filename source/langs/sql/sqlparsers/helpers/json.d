module langs.sql.sqlparsers.helpers.json;

import langs.sql;

@safe:
bool isExpressionType(Json parsedSql, string typeName) {
  return parsedSql.expressionType == typeName;
}

bool expressionType(Json parsedSql, string typeName) {
  if (!parsedSql.isObject || !parsedSql.isSet("expr_type")) {
    return false;
  }

  return parsedSql["expr_type"].get!string;
}

string baseExpression(Json parsedSql) {
  if (!parsedSql.isObject || !parsedSql.isSet("base_expr")) {
    return null;
  }

  return parsedSql.baseExpression;
}