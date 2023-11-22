module langs.sql.sqlparsers.builders.direction;

import lang.sql;

@safe:
/**
 * Builds direction (e.g. of the order-by clause).
 * This class : the builder for directions (e.g. of the order-by clause). 
 * You can overwrite all functions to achieve another handling.
 * */
class DirectionBuilder : IBuilder {

    string build(Json parsedSQL) {
        if ("direction" !in parsedSQL["direction"] || parsedSQL["direction"] == false) {
            return "";
        }
        return (" " ~ parsedSQL["direction"]);
    }
}
