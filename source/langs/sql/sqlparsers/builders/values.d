module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the VALUES part of the INSERT statement. */
 * This class : the builder for the VALUES part of INSERT statement. 
 */
class ValuesBuilder : ISqlBuilder {

    protected string buildRecord(Json parsedSql) {
        auto myBuilder = new RecordBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = "";
        foreach (myKey, myValue; parsedSql) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildRecord(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("VALUES", myKey, myValue, "expr_type");
            }

            mySql ~= this.getRecordDelimiter(myValue);
        }
        return "VALUES " . ySql.strip;
    }

    protected auto getRecordDelimiter(Json parsedSql) {
        return empty(parsedSql["delim"]) ? " " : parsedSql["delim"] . " ";
    }
}
