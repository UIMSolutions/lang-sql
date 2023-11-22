module langs.sql.sqlparsers.builders.update.update;

import lang.sql;

@safe:

/**
 * Builds the UPDATE statement parts. 
 * This class : the builder for the UPDATE statement parts. 
 * You can overwrite all functions to achieve another handling. */
class UpdateBuilder : ISqlBuilder {

    protected auto buildTable(parsedSQL, $idx) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSQL, $idx);
    }

    string build(Json parsedSQL) {
        string mySql = "";

        foreach (myKey, myValue; parsedSQL) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildTable(myValue, $k);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("UPDATE table list", myKey, myValue, "expr_type");
            }
        }
        return "UPDATE " ~ mySql;
    }
}
