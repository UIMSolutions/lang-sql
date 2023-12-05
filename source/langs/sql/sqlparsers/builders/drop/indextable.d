module langs.sql.sqlparsers.builders.drop.indextable;

import lang.sql;

@safe:

// Builder for the table part of a DROP INDEX statement.
class DropIndexTableBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isSet("on") || parsedSql["on"].isEmpty) {
      return null;
    }
    auto onSql = parsedSql["on"];
    if (!onSql.isExpressionType("TABLE")) {
      return "";
    }
    return "ON " ~ onSql["name"];
  }

}
