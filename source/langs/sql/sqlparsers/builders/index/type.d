module langs.sql.sqlparsers.builders.index.type;

import lang.sql;

@safe:

// Builds index type part of a PRIMARY KEY statement part of CREATE TABLE.
class IndexTypeBuilder : ISqlBuilder {

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("INDEX_TYPE")) {
      return null;
    }

    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildReserved(myValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE primary key index type subtree", myKey, myValue, "expr_type");
    }

    result ~= " ";
    return result;
  }
}
