module langs.sql.parsers.builders.position;

import langs.sql;

@safe:

// Builds positions of the GROUP BY clause. 
class PositionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("POSITION")) {
      return "";
    }
    
    return parsedSql.baseExpression;
  }
}
