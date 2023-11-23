module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds operators.
 * This class : the builder for operators. 
 *  */
class OperatorBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(OPERATOR) {
            return "";
        }
        return parsedSql["base_expr"];
    }
}
