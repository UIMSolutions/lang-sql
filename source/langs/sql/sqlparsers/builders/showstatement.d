module langs.sql.sqlparsers.builders.showstatement;

import lang.sql;

@safe:

// Builds the SHOW statement.
class ShowStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = this.buildShow(parsedSql);
    if (parsedSql.isSet("WHERE")) {
      mySql ~= " " ~ this.buildWhere(parsedSql["WHERE"]);
    }
    return mySql;
  }

  protected string buildWhere(Json parsedSql) {
    auto myBuilder = new WhereBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildShow(Json parsedSql) {
    auto myBuilder = new ShowBuilder();
    return myBuilder.build(parsedSql);
  }
}
