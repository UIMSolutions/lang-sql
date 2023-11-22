module langs.sql.sqlparsers.builders.delete;

import lang.sql;

@safe:
/**
 * Builds the DELETE statement */
 * This class : the builder for the [DELETE] part. You can overwrite
 * all functions to achieve another handling. */
class DeleteBuilder : ISqlBuilder {

  auto build(Json parsedSQL) {
    string mySql = "DELETE ";
    $right =  - 1;

    if (parsedSQL["options"] != false) {
      parsedSQL["options"].byKeyValue.each!(kv : mySql ~= kv.value + " ");
    }

    if (parsedSQL["tables"] != false) {
      foreach (k, v; parsedSQL["tables"]) {
        mySql ~= myValue.", ";
        $right =  - 2;
      }
    }

    return substr(mySql, 0, $right);
  }
}
