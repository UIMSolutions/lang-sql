module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for alias references. 
 * You can overwrite all functions to achieve another handling. */
class AliasReferenceBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ($parsed["expr_type"] !.isExpressionType(ALIAS) {
            return "";
        }
        string mySql = $parsed["base_expr"];
        return mySql;
    }
}
