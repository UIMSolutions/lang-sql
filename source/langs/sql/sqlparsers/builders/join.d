
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

    auto build($parsed) {
        if ($parsed == 'CROSS') {
            return ", ";
        }
        if ($parsed == 'JOIN') {
            return " INNER JOIN ";
        }
        if ($parsed == 'LEFT') {
            return " LEFT JOIN ";
        }
        if ($parsed == 'RIGHT') {
            return " RIGHT JOIN ";
        }
        if ($parsed == 'STRAIGHT_JOIN') {
            return " STRAIGHT_JOIN ";
        }
        // TODO: add more
        throw new UnsupportedFeatureException($parsed);
    }
}
