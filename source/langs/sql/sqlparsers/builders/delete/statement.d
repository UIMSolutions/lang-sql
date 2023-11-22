module langs.sql.sqlparsers.builders.delete.statement;

import lang.sql;

@safe:
/**
 * Builds the DELETE statement 
 * This class : the builder for the whole Delete statement. You can overwrite
 * all functions to achieve another handling. */
class DeleteStatementBuilder : ISqlBuilder {
  protected auto buildWhere(parsedSQL) {
    auto myBuilder = new WhereBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildFrom(parsedSQL) {
    auto myBuilder = new FromBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildDelete(parsedSQL) {
    auto myBuilder = new DeleteBuilder();
    return myBuilder.build(parsedSQL);
  }

  string build(Json parsedSQL) {
    string mySql = this.buildDelete(parsedSQL["DELETE"]) ~ " " ~ this.buildFrom(parsedSQL["FROM"]);
    if (parsedSQL.isSet("WHERE")) {
      mySql ~= " " ~ this.buildWhere(parsedSQL["WHERE"]);
    }
    return mySql;
  }

}
