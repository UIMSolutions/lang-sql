module lang.sql.parsers.builders;

import lang.sql;

@safe:
class AlterStatementBuilder : IBuilder {
  protected auto buildSubTree($parsed) {
    auto myBuilder = new SubTreeBuilder();
    return myBuilder.build($parsed);
  }

  private auto buildAlter($parsed) {
    auto myBuilder = new AlterBuilder();
    return myBuilder.build($parsed);
  }

  auto build(Json parsedSQL) {
    auto myAlter = $parsed["ALTER"];
    string mySql = this.buildAlter(myAlterr);

    return mySql;
  }
}
