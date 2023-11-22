module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for alias references. 
 *  */
class AliasReferenceBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(ALIAS) {
            return "";
        }
        string mySql = parsedSql["base_expr"];
        return mySql;
    }
}
