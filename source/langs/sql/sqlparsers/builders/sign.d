module langs.sql.sqlparsers.builders.sign;

import lang.sql;

@safe:

/**
 * Builds unary operators. 
 * This class : the builder for unary operators. 
 *  */
class SignBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("SIGN")) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
