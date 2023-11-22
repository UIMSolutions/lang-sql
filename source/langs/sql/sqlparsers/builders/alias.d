module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AliasBuilder : ISqlBuilder {

  auto hasAlias(parsed) {
    return ("alias" in parsed);
  }

  string build(Json parsedSQL) {
    if ("alias" !in parsed || parsedSQL["alias"] == false) {
      return "";
    }

    string mySql = "";
    auto subParsed = parsedSQL["alias"];
    if ("as" in subParsed) {
      mySql ~= " AS";
    }
    mySql ~= " " ~ subParsed["name"];
    return mySql;
  }
}
