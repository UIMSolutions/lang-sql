module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * Builds functions within the ORDER-BY part. 
 * This class : the builder for functions within the ORDER-BY part. 
 * It must contain the direction. 
 *  */
class OrderByFunctionBuilder : FunctionBuilder {

  protected auto buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }

  string build(Json parsedSql) {
    auto mySql = super.build(parsedSql);
    if (mySql != "") {
      mySql ~= this.buildDirection(parsedSql);
    }
    return mySql;
  }

}
