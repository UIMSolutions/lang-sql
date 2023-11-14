/**
 * DeleteBuilder.php
 *
 * Builds the DELETE statement */

module langs.sql.PHPSQLParser.builders.delete;

import lang.sql;

@safe:
/**
 * This class : the builder for the [DELETE] part. You can overwrite
 * all functions to achieve another handling. */
class DeleteBuilder : ISqlBuilder {

  auto build(array$parsed) {
    auto mySql = "DELETE ";
    $right =  - 1;

    if ($parsed["options"] != false) {
      $parsed["options"].byKeyValue.each!(kv :  mySql ~= kv.value + " ");
    }

    if ($parsed["tables"] != false) {
      foreach (k, v; $parsed["tables"]) {
        mySql ~= myValue.", ";
        $right =  - 2;
      }
    }

    return substr(mySql, 0, $right);
  }
}
