
/**
 * ValuesBuilder.php
 *
 * Builds the VALUES part of the INSERT statement. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the VALUES part of INSERT statement. 
 * You can overwrite all functions to achieve another handling. */
class ValuesBuilder : ISqlBuilder {

    protected auto buildRecord($parsed) {
        auto myBuilder = new RecordBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildRecord(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('VALUES', $k, myValue, "expr_type");
            }

            mySql  ~= this.getRecordDelimiter(myValue);
        }
        return "VALUES " . trim(mySql);
    }

    protected auto getRecordDelimiter($parsed) {
        return empty($parsed["delim"]) ? " " : $parsed["delim"] . " ";
    }
}
