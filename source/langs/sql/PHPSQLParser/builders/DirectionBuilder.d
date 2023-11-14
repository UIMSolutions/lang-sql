module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * Builds direction (e.g. of the order-by clause).
 * This class : the builder for directions (e.g. of the order-by clause). 
 * You can overwrite all functions to achieve another handling.
 * */
class DirectionBuilder : IBuilder {

    auto build(array $parsed) {
        if ("direction" !in $parsed["direction"] || $parsed["direction"] == false) {
            return "";
        }
        return (" "~ $parsed["direction"]);
    }
}
