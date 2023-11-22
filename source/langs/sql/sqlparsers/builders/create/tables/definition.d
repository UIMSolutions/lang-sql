module langs.sql.sqlparsers.builders.create.tables.definition;

import lang.sql;

@safe:
/**
 * Builds the create definitions of CREATE TABLE.
 * This class : the builder for the create definitions of CREATE TABLE. 
 *  */
class CreateTableDefinitionBuilder : ISqlBuilder {

    protected auto buildTableBracketExpression(parsedSql) {
        auto myBuilder = new TableBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!isset(parsedSql) || parsedSql["create-def"] == false) {
            return "";
        }
        return this.buildTableBracketExpression(parsedSql["create-def"]);
    }
}
