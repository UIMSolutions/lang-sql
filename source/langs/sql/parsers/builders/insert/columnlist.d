module langs.sql.parsers.builders.insert.columnlist;

import langs.sql;

@safe:

// Builds column-list parts of INSERT statements.
class InsertColumnListBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("COLUMN_LIST")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return "(" ~ substr(mySql, 0, -2) ~ ")";
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildColumn(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("INSERT column-list subtree", aKey, aValue, "expr_type");
    }

    result ~= ", ";
    return result;
  }

  protected string buildColumn(Json parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }
}
