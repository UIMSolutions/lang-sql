module lang.sql.parsers.builders;

import lang.sql;

@safe:
// Builds functions within the ORDER-BY part. 
class OrderByFunctionBuilder : FunctionBuilder {

  string build(Json parsedSql) {
    auto mySql = super.build(parsedSql);
    if (mySql != "") {
      mySql ~= this.buildDirection(parsedSql);
    }
    return mySql;
  }

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }
}
