module langs.sql.sqlparsers.builders.create.tables.check;

import langs.sql;

@safe:

// Builds the CHECK statement part of CREATE TABLE. 
class CheckBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("CHECK")) {
      return "";
    }

    // Main
    string mySql = parsedSql["sub_tree"].byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .join;

    return substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~=
      buildReserved(aValue) ~
      buildSelectBracketExpression(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("CREATE TABLE check subtree", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildSelectBracketExpression(Json parsedSql) {
    auto myBuilder = new SelectBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }
}

unittest {
  auto builder = new CheckBuilder;
  assert(builder, "Could not create CheckBuilder");
}