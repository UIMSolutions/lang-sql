module langs.sql.sqlparsers.builders.uniqueindex;

import lang.sql;

@safe:

// Builds index key part of a CREATE TABLE statement. 
class UniqueIndexBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("UNIQUE_IDX")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildReserved(aValue);
    result ~= this.buildColumnList(aValue);
    result ~= this.buildConstant(aValue);
    result ~= this.buildIndexType(aValue);
    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE unique-index key subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexType(Json parsedSql) {
    auto myBuilder = new IndexTypeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildColumnList(Json parsedSql) {
    auto myBuilder = new ColumnListBuilder();
    return myBuilder.build(parsedSql);
  }
}
