module langs.sql.sqlparsers.builders.delete;

import lang.sql;

@safe:
// Builds the DELETE statement
class DeleteBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = "DELETE ";
     myright =  - 1;

    if (parsedSql["options"] != false) {
      parsedSql["options"].byKeyValue.each!(kv : mySql ~= kv.value + " ");
    }

    if (parsedSql["tables"] != false) {
      foreach (k, v; parsedSql["tables"]) {
        mySql ~= myValue.", ";
         myright =  - 2;
      }
    }

    return substr(mySql, 0,  myright);
  }
}
