module langs.sql.parsers.builders;

import langs.sql;

@safe:

// Builds the LIMIT statement.
class LimitBuilder : ISqlBuilder {

  string build(Json parsedSql) {
    string mySql = (parsedSql["rowcount"].get!string) ~
      (parsedSql["offset"].get!string
          ? " OFFSET " ~ parsedSql["offset"].get!string : "");

    if (mySql.isEmpty) {
      throw new UnableToCreateSQLException("LIMIT", "rowcount", parsedSql, "rowcount");
    }
    return "LIMIT " ~ mySql;
  }
}
