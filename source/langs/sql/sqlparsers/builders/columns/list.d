module langs.sql.sqlparsers.builders.columns.list;

import langs.sql;

@safe:

/**
 * Builds column-list parts of CREATE TABLE. 
 * This class : the builder for column-list parts of CREATE TABLE. 
 */
class ColumnListBuilder : ISqlBuilder {

  string build(Json parsedSql, string delim = ", ") {
    if (!parsedSql.isExpressionType("COLUMN_LIST")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return "(" ~ mySql[0 .. my - delim.length] ~ ")";
  }

  protected string buildKeyValue(string aKey, Json aValue, string delim) {
    string result;

    result ~= this.buildIndexColumn(aValue);
    result ~= this.buildColumnReference(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE column-list subtree", aKey, aValue, "expr_type");
    }

    result ~= delim;
    return result;
  }

  protected string buildIndexColumn(Json parsedSql) {
    auto myBuilder = new IndexColumnBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildColumnReference(Json parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }
}
