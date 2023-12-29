module langs.sql.sqlparsers.builders.index.hintlist;

import langs.sql;

@safe:
// Builds the index hint list of a table.
class IndexHintListBuilder : ISqlBuilder {

  auto hasHint(Json parsedSql) {
    return isset(parsedSql["hints"]);
  }

  // TODO: the hint list should be enhanced to get base_expr fro position calculation
  string build(Json parsedSql) {
    if (!parsedSql.isSet("hints") || parsedSql["hints"].isEmpty) {
      return "";
    }

    string mySql = "";
    foreach (myKey, myValue; parsedSql["hints"]) {

    }
    return " " ~ substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= myValue["hint_type"] ~ " " ~ myValue["hint_list"] ~ " ";

    return result;
  }
}
