module langs.sql.sqlparsers.builders.truncate;
import lang.sql;

@safe:
// Builds the TRUNCATE statement
class TruncateBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = "TRUNCATE TABLE ";
    auto myRight = -1;

    // works for one table only
    parsedSql["tables"] = [parsedSql["TABLE"].baseExpression];

    if (parsedSql["tables"] != false) {
      foreach (myKey, myValue; parsedSql["tables"]) {
        mySql ~= myValue ~ ", ";
        myRight = -2;
      }
    }

    return substr(mySql, 0, myRight);
  }
}
