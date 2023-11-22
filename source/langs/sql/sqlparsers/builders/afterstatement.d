module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AlterStatementBuilder : IBuilder {
  protected auto buildSubTree(Json parsedSql) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSql);
  }

  private auto buildAlter(Json parsedSql) {
    auto myBuilder = new AlterBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    auto myAlter = parsedSql["ALTER"];
    string mySql = this.buildAlter(myAlterr);

    return mySql;
  }
}
