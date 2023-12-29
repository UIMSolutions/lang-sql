module langs.sql.sqlparsers.builders.direction;

import langs.sql;

@safe:
// Builds direction (e.g. of the order-by clause).
class DirectionBuilder : IBuilder {

  string build(Json parsedSql) {
    if (!parsedSql.isSet("direction") || parsedSql["direction"].isEmpty) {
      return "";
    }
    return " " ~ parsedSql["direction"].get!string;
  }
}
