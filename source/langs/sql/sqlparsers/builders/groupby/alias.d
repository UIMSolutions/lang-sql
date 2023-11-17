module langs.sql.PHPSQLParser.builders.groupby.alias;

import lang.sql;

@safe:

/**
 * Builds an alias within a GROUP-BY clause.
 * This class : the builder for an alias within the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class GroupByAliasBuilder : ISqlBuilder {

    string build(array $parsed) {
        if ($parsed["expr_type"] !.isExpressionType(ALIAS) {
            return "";
        }
        return $parsed["base_expr"];
    }
}