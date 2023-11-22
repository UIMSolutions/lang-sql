module langs.sql.sqlparsers.builders.create.tables.options;

import lang.sql;

@safe:

/**
 * Builds the table-options statement part of CREATE TABLE.
 * This class : the builder for the table-options statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CreateTableOptionsBuilder : IBuilder {

    protected auto buildExpression(parsedSQL) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildCharacterSet(parsedSQL) {
        auto myBuilder = new CharacterSetBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildCollation(parsedSQL) {
        auto myBuilder = new CollationBuilder();
        return myBuilderr.build(parsedSQL);
    }

    /**
     * Returns a well-formatted delimiter string. If you don"t need nice SQL,
     * you could simply return parsedSQL["delim"].
     * 
     * @param Json parsedSQL The part of the output array, which contains the current expression.
     * @return a string, which is added right after the expression
     */
    protected auto getDelimiter(parsedSQL) {
        return (parsedSQL["delim"] == false ? "" : (parsedSQL["delim"]) . " ").strip;
    }

    string build(Json parsedSQL) {
        if (!isset(parsedSQL["options"]) || parsedSQL["options"] == false) {
            return "";
        }
        $options = parsedSQL["options"];
        string mySql = "";
        foreach ($options as myKey, myValue) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildExpression(myValue);
            mySql ~= this.buildCharacterSet(myValue);
            mySql ~= this.buildCollation(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE options", myKey, myValue, "expr_type");
            }

            mySql ~= this.getDelimiter(myValue);
        }
        return " " ~ substr(mySql, 0, -1);
    }
}
