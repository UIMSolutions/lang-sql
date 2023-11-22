module langs.sql.sqlparsers.helpers.json;

import langs.sql;

@safe:
bool isExpressionType(Json sqlPart, string typeName) {
  if (!sqlPart.isObject || !sqlPart.isSet("expr_type")) {
    return false;
  }

  return sqlPart["expr_type"].get!string == typeName;
}
