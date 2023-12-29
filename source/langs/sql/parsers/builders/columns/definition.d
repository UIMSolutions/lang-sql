module langs.sql.parsers.builders.columns.definition;

import langs.sql;

@safe:
// Builds the column definition statement part of CREATE TABLE. 
class ColumnDefinitionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    // In Check
    if (!parsedSql.isExpressionType("COLDEF")) {
      return null;
    }

    // Main
    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildColRef(aValue);
    result ~= this.buildColumnType(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE primary key subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildColRef(Json parsedSql) {
    auto myBuilder = new ColumnReferenceBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildColumnType(Json parsedSql) {
    auto myBuilder = new ColumnTypeBuilder();
    return myBuilder.build(parsedSql);
  }

}
