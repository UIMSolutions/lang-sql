module langs.sql.sqlparsers.builders.create.tables.defaulvalue;

import lang.sql;

@safe:

/**
 * Builds the default value statement part of a column of a CREATE TABLE. 
 * This class : the builder for the default value statement part of CREATE TABLE. 
 */
class DefaultValueBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("DEF_VALUE") {
            return "";
        }
        return parsedSql.baseExpression;
    }
}
