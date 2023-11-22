module langs.sql.sqlparsers.builders.orderby.OrderByPositionBuilder;

import lang.sql;

@safe:

/**
 * Builds positions of the GROUP BY clause. 
 * This class : the builder for positions of the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling. */
class OrderByPositionBuilder : ISqlBuilder {
    protected auto buildDirection(parsedSQL) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(POSITION) {
            return "";
        }
        return parsedSQL["base_expr"] ~ this.buildDirection(parsedSQL);
    }
}
