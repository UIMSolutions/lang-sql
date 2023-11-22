module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AlterBuilder : ISqlBuilder {
  auto build(Json parsedSQL) {
    string mySql = "";

    foreach (myTerm; $parsed) {
      if (myTerm == " ") {
        continue;
      }

      if (substr(myTerm, 0, 1) == "(" ||
        strpos(myTerm, "\n") != false) {
        mySql = rtrim(mySql);
      }

      mySql ~= myTerm." ";
    }

    mySql = mySql.rstrip;

    return mySql;
  }
}
