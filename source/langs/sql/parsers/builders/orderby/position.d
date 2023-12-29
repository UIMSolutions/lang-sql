module langs.sql.parsers.builders.orderby.position;

import langs.sql;

@safe:

// Builds positions of the GROUP BY clause. 
class OrderByPositionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("POSITION")) {
      return "";
    }
    return parsedSql.baseExpression ~ this.buildDirection(parsedSql);
  }

  protected string buildDirection(Json parsedSql) {
    auto myBuilder = new DirectionBuilder();
    return myBuilder.build(parsedSql);
  }
}
