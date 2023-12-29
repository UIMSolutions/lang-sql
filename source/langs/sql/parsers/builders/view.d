module langs.sql.parsers.builders.view;

import langs.sql;

@safe:

// Builds the view within the DROP statement. 
class ViewBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isExpressionType("VIEW")) {
      return "";
    }
    return parsedSql.baseExpression;
  }
}
