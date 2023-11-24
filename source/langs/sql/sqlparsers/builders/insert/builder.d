module langs.sql.sqlparsers.builders.insert.builder;

import lang.sql;

@safe:

// Builds the [INSERT] statement part.
class InsertBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = "";
    foreach (myKey, myValue; parsedSql) {

    }
    return "INSERT ".substr(mySql, 0, -1);
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
