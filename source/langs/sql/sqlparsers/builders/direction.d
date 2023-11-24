module langs.sql.sqlparsers.builders.direction;

import lang.sql;

@safe:
/**
 * Builds direction (e.g. of the order-by clause).
 * */
class DirectionBuilder : IBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isSet("direction") || parsedSql["direction"] == false) {
      return "";
    }
    return (" " ~ parsedSql["direction"].get!string);
  }
}
