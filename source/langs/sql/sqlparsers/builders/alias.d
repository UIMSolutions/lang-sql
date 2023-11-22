module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AliasBuilder : ISqlBuilder {

  auto hasAlias(parsed) {
    return ("alias" in parsed);
  }

  string build(Json parsedSql) {
    if ("alias" !in parsed || parsedSql["alias"] == false) {
      return "";
    }

    string mySql = "";
    auto subParsed = parsedSql["alias"];
    if ("as" in subParsed) {
      mySql ~= " AS";
    }
    mySql ~= " " ~ subParsed["name"];
    return mySql;
  }
}
