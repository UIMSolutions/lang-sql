
/**
 * Builds the view within the DROP statement. */

module langs.sql.sqlparsers.builders.view;

import lang.sql;

@safe:

/**
 * This class : the builder for a view within DROP statement. 
 *  */
class ViewBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(VIEW) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
