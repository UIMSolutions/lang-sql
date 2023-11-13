module lang.sql.parsers.builders;

class AliasBuilder : ISqlBuilder {

  auto hasAlias(parsed) {
    return ("alias" in parsed);
  }

  auto build(array$parsed) {
    if (!isset($parsed["alias"]) || $parsed["alias"] == false) {
      return "";
    }

    auto mySql = "";
    if ($parsed["alias"]["as"]) {
      mySql ~= " AS";
    }
    mySql ~= " ".$parsed["alias"]["name"];
    return mySql;
  }
}
