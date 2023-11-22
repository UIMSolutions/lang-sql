module langs.sql.sqlparsers.builders.create.tables.definition;

import lang.sql;

@safe:
/**
 * Builds the create definitions of CREATE TABLE.
 * This class : the builder for the create definitions of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CreateTableDefinitionBuilder : ISqlBuilder {

    protected auto buildTableBracketExpression(parsedSQL) {
        auto myBuilder = new TableBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (!isset(parsedSQL) || parsedSQL["create-def"] == false) {
            return "";
        }
        return this.buildTableBracketExpression(parsedSQL["create-def"]);
    }
}
