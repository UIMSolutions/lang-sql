module langs.sql.sqlparsers.builders.create.tables.table;

import lang.sql;

@safe:
/**
 * Builds the CREATE TABLE statement
 * This class : the builder for the CREATE TABLE statement. You can overwrite
 * all functions to achieve another handling.   */
class CreateTableBuilder : ISqlBuilder {

  protected auto buildCreateTableDefinition($parsed) {
    auto myBuilder = new CreateTableDefinitionBuilder();
    return myBuilder.build($parsed);
  }

  protected auto buildCreateTableOptions($parsed) {
    auto myBuilder = new CreateTableOptionsBuilder();
    return myBuilder.build($parsed);
  }

  protected auto buildCreateTableSelectOption($parsed) {
    auto myBuilder = new CreateTableSelectOptionBuilder();
    return myBuilder.build($parsed);
  }

  string build(array$parsed) {
    string mySql = $parsed["name"];
    mySql ~= this.buildCreateTableDefinition($parsed);
    mySql ~= this.buildCreateTableOptions($parsed);
    mySql ~= this.buildCreateTableSelectOption($parsed);
    return mySql;
  }

}
