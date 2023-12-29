module langs.sql.sqlparsers.builders.delete_;

import langs.sql;

@safe:
// Builds the DELETE statement
class DeleteBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = "DELETE ";

    if (!parsedSql["options"].isEmpty) {
     mySql ~= parsedSql["options"].byKeyValue.map!(kv => kv.value ~ " ").join(" ");
    }

    if (!parsedSql["tables"].isEmpty) {
     mySql ~= parsedSql["tables"].byKeyValue.map!(kv => kv.value).join(", ");
    }

    return mySql;
  }
}
