module langs.sql.parsers.builders.create.tables.foreignkey;

import langs.sql;

@safe:

// Builds the FOREIGN KEY statement part of CREATE TABLE. 
class ForeignKeyBuilder : IBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("FOREIGN_KEY")) {
      return "";
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;

    result ~= this.buildConstant(aValue);
    result ~= this.buildReserved(aValue);
    result ~= this.buildColumnList(aValue);
    result ~= this.buildForeignRef(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE foreign key subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildConstant(Json parsedSql) {
    auto myBuilder = new ConstantBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildColumnList(Json parsedSql) {
    auto myBuilder = new ColumnListBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildForeignRef(Json parsedSql) {
    auto myBuilder = new ForeignRefBuilder();
    return myBuilder.build(parsedSql);
  }
}

unittest {
  auto builder = new ForeignKeyBuilder;
  assert(builder, "Could not create ForeignKeyBuilder");
}