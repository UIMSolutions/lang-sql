module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AliasBuilder : ISqlBuilder {

  auto hasAlias(parsed) {
    return ("alias" in parsed);
  }

  string build(array $parsed) {
    if ("alias" !in parsed || $parsed["alias"] == false) {
      return "";
    }

    string mySql = "";
    auto subParsed = $parsed["alias"];
    if ("as" in subParsed) {
      mySql ~= " AS";
    }
    mySql ~= " " ~ subParsed["name"];
    return mySql;
  }
}
