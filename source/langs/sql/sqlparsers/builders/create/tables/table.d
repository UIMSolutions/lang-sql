module langs.sql.sqlparsers.builders.create.tables.table;

import lang.sql;

@safe:
/**
 * Builds the CREATE TABLE statement
 * This class : the builder for the CREATE TABLE statement. You can overwrite
 * all functions to achieve another handling.   */
class CreateTableBuilder : ISqlBuilder {

  protected auto buildCreateTableDefinition(parsedSQL) {
    auto myBuilder = new CreateTableDefinitionBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildCreateTableOptions(parsedSQL) {
    auto myBuilder = new CreateTableOptionsBuilder();
    return myBuilder.build(parsedSQL);
  }

  protected auto buildCreateTableSelectOption(parsedSQL) {
    auto myBuilder = new CreateTableSelectOptionBuilder();
    return myBuilder.build(parsedSQL);
  }

  string build(Json parsedSQL) {
    string mySql = parsedSQL["name"];
    mySql ~= this.buildCreateTableDefinition(parsedSQL);
    mySql ~= this.buildCreateTableOptions(parsedSQL);
    mySql ~= this.buildCreateTableSelectOption(parsedSQL);
    return mySql;
  }

}
