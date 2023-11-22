
module langs.sql.sqlparsers.builders.join;

import lang.sql;

@safe:
/**
 * Builds the JOIN statement parts (within FROM).
 * This class : the builder for the JOIN statement parts (within FROM). 
 * You can overwrite all functions to achieve another handling.
 *
 

 
 *   */
class JoinBuilder {

    auto build(parsedSQL) {
        if (parsedSQL == "CROSS") {
            return ", ";
        }
        if (parsedSQL == "JOIN") {
            return " INNER JOIN ";
        }
        if (parsedSQL == "LEFT") {
            return " LEFT JOIN ";
        }
        if (parsedSQL == "RIGHT") {
            return " RIGHT JOIN ";
        }
        if (parsedSQL == "STRAIGHT_JOIN") {
            return " STRAIGHT_JOIN ";
        }
        // TODO: add more
        throw new UnsupportedFeatureException(parsedSQL);
    }
}
