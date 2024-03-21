module langs.sql.parsers.builders.view;

import langs.sql;

@safe:

// Builds the view within the DROP statement. 
class DViewBuilder : ISqlBuilder {
  string build(Json parsedSql) {
    return parsedSql.isExpressionType("VIEW")
? parsedSql.baseExpression 
: null;

}
auto ViewBuilder() { return new DViewBuilder; }
