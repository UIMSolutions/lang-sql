module langs.sql.sqlparsers.builders.delete.statement;

import lang.sql;

@safe:
/**
 * Builds the DELETE statement 
 * This class : the builder for the whole Delete statement. You can overwrite
 * all functions to achieve another handling. */
class DeleteStatementBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = this.buildDelete(parsedSql["DELETE"]) ~ " " ~ this.buildFrom(parsedSql["FROM"]);
    if (parsedSql.isSet("WHERE")) {
      mySql ~= " " ~ this.buildWhere(parsedSql["WHERE"]);
    }
    return mySql;
  }

  protected auto buildWhere(Json parsedSql) {
    auto myBuilder = new WhereBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildFrom(Json parsedSql) {
    auto myBuilder = new FromBuilder();
    return myBuilder.build(parsedSql);
  }

  protected auto buildDelete(Json parsedSql) {
    auto myBuilder = new DeleteBuilder();
    return myBuilder.build(parsedSql);
  }

}
