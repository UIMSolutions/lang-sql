module langs.sql.sqlparsers.builders.orderby.position;

import lang.sql;

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
