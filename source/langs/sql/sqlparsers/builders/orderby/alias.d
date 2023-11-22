module langs.sql.sqlparsers.builders.orderby.alias;

import lang.sql;

@safe:

/**
 * Builds an alias within an ORDER-BY clause.
 * This class : the builder for an alias within the ORDER-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class OrderByAliasBuilder : ISqlBuilder {

    protected auto buildDirection(parsedSQL) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(ALIAS) {
            return "";
        }
        return parsedSQL["base_expr"] . this.buildDirection(parsedSQL);
    }
}
