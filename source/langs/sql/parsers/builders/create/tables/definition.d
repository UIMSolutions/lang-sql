module langs.sql.parsers.builders.create.tables.definition;

import langs.sql;

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

unittest {
  auto builder = new CreateTableDefinitionBuilder;
  assert(builder, "Could not create CreateTableDefinitionBuilder");
}
