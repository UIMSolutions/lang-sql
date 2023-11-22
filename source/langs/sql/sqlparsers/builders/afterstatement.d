module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AlterStatementBuilder : IBuilder {
  protected auto buildSubTree(parsedSQL) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build(parsedSQL);
  }

  private auto buildAlter(parsedSQL) {
    auto myBuilder = new AlterBuilder();
    return myBuilder.build(parsedSQL);
  }

  auto build(Json parsedSQL) {
    auto myAlter = parsedSQL["ALTER"];
    string mySql = this.buildAlter(myAlterr);

    return mySql;
  }
}
