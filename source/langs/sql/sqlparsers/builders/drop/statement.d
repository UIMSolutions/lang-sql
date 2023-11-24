module langs.sql.sqlparsers.builders.drop.statement;

import lang.sql;

@safe:
// Builds the DROP statement
class DropStatementBuilder : IBuilder {

  string build(Json parsedSql) {
    return this.buildDROP(parsedSql);
  }

  protected string buildDROP(parsedSql) {
    auto myBuilder = new DropBuilder();
    return myBuilder.build(parsedSql);
  }

}
