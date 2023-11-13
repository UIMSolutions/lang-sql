
/**
 * CreateTable.php
 *
 * Builds the CREATE TABLE statement
 *
 *
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for the CREATE TABLE statement. You can overwrite
 * all functions to achieve another handling.  
 */
class CreateTableBuilder : ISqlBuilder {

    protected auto buildCreateTableDefinition($parsed) {
        $builder = new CreateTableDefinitionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildCreateTableOptions($parsed) {
        $builder = new CreateTableOptionsBuilder();
        return $builder.build($parsed);
    }

    protected auto buildCreateTableSelectOption($parsed) {
        $builder = new CreateTableSelectOptionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = $parsed["name"];
        mySql  ~= this.buildCreateTableDefinition($parsed);
        mySql  ~= this.buildCreateTableOptions($parsed);
        mySql  ~= this.buildCreateTableSelectOption($parsed);
        return mySql;
    }

}