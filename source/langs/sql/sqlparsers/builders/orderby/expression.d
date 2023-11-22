module lang.sql.parsers.builders;

import lang.sql;

@safe:
// Builds expressions within the ORDER-BY part. It must contain the direction.
class OrderByExpressionBuilder : WhereExpressionBuilder {

  string build(Json parsedSql) {
    string result = super.build(parsedSql);
    if (!result.isEmpty) {
      result ~= this.buildDirection(parsedSql);
    }
    return result;
  }

  protected auto buildDirection(Json parsedSql) {
    auto auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }

}
