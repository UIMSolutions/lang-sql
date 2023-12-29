module langs.sql.sqlparsers.builders.insert.builder;

import langs.sql;

@safe:

// Builds the [INSERT] statement part.
class InsertBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = parsedSql.byKeyValue
      .map!(kv => buildKeyValue(kv.key, kv.value))
      .json;
      
    return "INSERT ".substr(mySql, 0, -1);
  }

  protected string buildKeyValue(string aKey, Json aValue) {
    string result;
    result ~= this.buildTable(aValue);
    result ~= this.buildSubQuery(aValue);
    result ~= this.buildColumnList(aValue);
    result ~= this.buildReserved(myValue);
    result ~= this.buildBracketExpression(aValue);

    if (result.isEmpty) { // No change
      throw new UnableToCreateSQLException("INSERT", aKey, aValue, "expr_type");
    }

    result ~= " ";
    return result;
  }

  protected string buildTable(Json parsedSql) {
    auto myBuilder = new TableBuilder();
    return myBuilder.build(parsedSql, 0);
  }

  protected string buildSubQuery(Json parsedSql) {
    auto myBuilder = new SubQueryBuilder();
    return myBuilder.build(parsedSql, 0);
  }

  protected string buildReserved(Json parsedSql) {
    auto myBuilder = new ReservedBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildBracketExpression(Json parsedSql) {
    auto myBuilder = new SelectBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildColumnList(Json parsedSql) {
    auto myBuilder = new InsertColumnListBuilder();
    return myBuilder.build(parsedSql, 0);
  }
}
