module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the LIMIT statement.
 * This class : the builder LIMIT statement. 
 * You can overwrite all functions to achieve another handling. */
class LimitBuilder : ISqlBuilder {

    string build(Json parsedSQL) {
        string mySql = ($parsed["rowcount"]) . ($parsed["offset"] ? " OFFSET " . $parsed["offset"] : "");
        if (mySql.isEmpty) {
            throw new UnableToCreateSQLException("LIMIT", "rowcount", $parsed, "rowcount");
        }
        return "LIMIT " . mySql;
    }
}
