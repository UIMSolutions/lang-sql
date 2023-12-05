module langs.sql.sqlparsers.builders.create.tables.primarykey;

import lang.sql;

@safe:

// Builds the PRIMARY KEY statement part of CREATE TABLE. 
class PrimaryKeyBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("PRIMARY_KEY")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;
      
    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildConstraint(aValue);
    result ~= this.buildReserved(aValue);
    result ~= this.buildColumnList(aValue);
    result ~= this.buildIndexType(aValue);
    result ~= this.buildIndexSize(aValue);
    result ~= this.buildIndexParser(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE primary key subtree", aKey, aValue, "expr_type");
    }

   mySql ~= " ";
    return result;
  }

  protected string buildColumnList(Json parsedSql) {
    auto myBuilder = new ColumnListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildConstraint(Json parsedSql) {
    auto myBuilder = new ConstraintBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexType(Json parsedSql) {
    auto myBuilder = new IndexTypeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexSize(Json parsedSql) {
    auto myBuilder = new IndexSizeBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildIndexParser(Json parsedSql) {
    auto myBuilder = new IndexParserBuilder();
    return myBuilder.build(parsedSql);
  }
}
