module langs.sql.parsers.builders;

import langs.sql;

@safe:
class AliasBuilder : ISqlBuilder {

  auto hasAlias(parsed) {
    return ("alias" in parsed);
  }

  string build(Json parsedSql) {
    if (parsedisSet("alias") || parsedSql["alias"].isEmpty) {
      return "";
    }

    string mySql = "";
    auto subParsed = parsedSql["alias"];
    if (subParsed.isSet("as")) {
     mySql ~= " AS";
    }
   mySql ~= " " ~ subParsed["name"];
    return mySql;
  }
}
