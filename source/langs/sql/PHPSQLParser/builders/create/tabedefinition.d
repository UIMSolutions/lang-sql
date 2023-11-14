
/**
 * CreateTableDefinitionBuilder.php
 *
 * Builds the create definitions of CREATE TABLE. */

module source.langs.sql.PHPSQLParser.builders.create.tabedefinition;

import lang.sql;

@safe:
/**
 * This class : the builder for the create definitions of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class CreateTableDefinitionBuilder : ISqlBuilder {

    protected auto buildTableBracketExpression($parsed) {
        auto myBuilder = new TableBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if (!isset($parsed) || $parsed["create-def"] == false) {
            return "";
        }
        return this.buildTableBracketExpression($parsed["create-def"]);
    }
}
