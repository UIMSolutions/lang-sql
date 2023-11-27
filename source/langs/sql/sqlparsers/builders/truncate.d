module langs.sql.sqlparsers.builders.truncate;

// Builds the TRUNCATE statement
class TruncateBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = "TRUNCATE TABLE ";
    $right =  - 1;

    // works for one table only
    parsedSql["tables"] = [parsedSql["TABLE"].baseExpression];

    if (parsedSql["tables"] != false) {
      foreach (myKey, myValue; parsedSql["tables"]) {
        mySql ~= myValue ~ ", ";
        $right =  - 2;
      }
    }

    return substr(mySql, 0, $right);
  }
}
