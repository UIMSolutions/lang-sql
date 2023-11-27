module lang.sql.parsers.builders;

import lang.sql;

@safe:

// Builds the VALUES part of the INSERT statement.
class ValuesBuilder : ISqlBuilder {

    protected string buildRecord(Json parsedSql) {
        auto myBuilder = new RecordBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = parsedSql.byKeyValue
            .map!(kv => buildKeyValue(kv.key, kv.value))
            .join;

        return "VALUES "~mySql.strip;
    }

    protected string buildKeyValue(string aKey, Json aValue) {
        string result;
        result ~= this.buildRecord(aValue);

        if (result.isEmpty) { // No change
            throw new UnableToCreateSQLException("VALUES", aKey, aValue, "expr_type");
        }

        result ~= this.getRecordDelimiter(aValue);
        return result;
    }

    protected auto getRecordDelimiter(Json parsedSql) {
        return empty(parsedSql["delim"]) ? " " : parsedSql["delim"]." ";
    }
}
