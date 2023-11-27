module langs.sql.sqlparsers.builders.orderby.OrderByPositionBuilder;

import lang.sql;

@safe:

// Builds positions of the GROUP BY clause. 
class OrderByPositionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("POSITION")) {
      return "";
    }
    return parsedSql["base_expr"] ~ this.buildDirection(parsedSql);
  }

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }
}
