module langs.sql.sqlparsers.builders.set;

import lang.sql;

@safe:

/**
 * Builds the SET part of the INSERT statement. */
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling. */
class SetBuilder : ISqlBuilder {

    protected auto buildSetExpression(parsedSQL) {
        auto myBuilder = new SetExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = "";
        foreach (myKey, myValue; parsedSQL) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildSetExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("SET", myKey, myValue, "expr_type");
            }

            mySql ~= ",";
        }
        return "SET " ~ substr(mySql, 0, -1);
    }
}
