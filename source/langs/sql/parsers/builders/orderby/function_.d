module langs.sql.sqlparsers.builders.orderby.function_;

import langs.sql;

@safe:
// Builds functions within the ORDER-BY part. 
class OrderByFunctionBuilder : FunctionBuilder {

  string build(Json parsedSql) {
    auto mySql = super.build(parsedSql);
    if (!mySql.isEmpty) {
     mySql ~= this.buildDirection(parsedSql);
    }
    return mySql;
  }

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }
}
