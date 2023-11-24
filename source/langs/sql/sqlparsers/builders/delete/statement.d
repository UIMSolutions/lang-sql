module langs.sql.sqlparsers.builders.delete.statement;

import lang.sql;

@safe:
// Builder for the whole Delete statement. 
class DeleteStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = this.buildDelete(parsedSql["DELETE"]) ~ " " ~ this.buildFrom(parsedSql["FROM"]);
    if (parsedSql.isSet("WHERE")) {
      mySql ~= " " ~ this.buildWhere(parsedSql["WHERE"]);
    }
    return mySql;
  }

  protected string buildWhere(Json parsedSql) {
    auto myBuilder = new WhereBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildFrom(Json parsedSql) {
    auto myBuilder = new FromBuilder();
    return myBuilder.build(parsedSql);
  }

  protected string buildDelete(Json parsedSql) {
    auto myBuilder = new DeleteBuilder();
    return myBuilder.build(parsedSql);
  }

}
