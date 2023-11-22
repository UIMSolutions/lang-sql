module langs.sql.sqlparsers.builders.delete;

import lang.sql;

@safe:
/**
 * Builds the DELETE statement */
 * This class : the builder for the [DELETE] part. You can overwrite
 * all functions to achieve another handling. */
class DeleteBuilder : ISqlBuilder {

  auto build(Json parsedSql) {
    string mySql = "DELETE ";
    $right =  - 1;

    if (parsedSql["options"] != false) {
      parsedSql["options"].byKeyValue.each!(kv : mySql ~= kv.value + " ");
    }

    if (parsedSql["tables"] != false) {
      foreach (k, v; parsedSql["tables"]) {
        mySql ~= myValue.", ";
        $right =  - 2;
      }
    }

    return substr(mySql, 0, $right);
  }
}
