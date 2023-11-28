module langs.sql.sqlparsers.builders.create.tables.definition;

import lang.sql;

@safe:
// Builds the create definitions of CREATE TABLE.
class CreateTableDefinitionBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    if (!isset(parsedSql) || parsedSql["create-def"].isEmpty) {
      return "";
    }
    return this.buildTableBracketExpression(parsedSql["create-def"]);
  }

  protected string buildTableBracketExpression(Json parsedSql) {
    auto myBuilder = new TableBracketExpressionBuilder();
    return myBuilder.build(parsedSql);
  }
}
