module langs.sql.sqlparsers.builders.create.tables.options;

import lang.sql;

@safe:

/**
 * Builds the table-options statement part of CREATE TABLE.
 * This class : the builder for the table-options statement part of CREATE TABLE. 
 *  */
class CreateTableOptionsBuilder : IBuilder {

    protected auto buildExpression(parsedSql) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildCharacterSet(parsedSql) {
        auto myBuilder = new CharacterSetBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildCollation(parsedSql) {
        auto myBuilder = new CollationBuilder();
        return myBuilderr.build(parsedSql);
    }

    /**
     * Returns a well-formatted delimiter string. If you don"t need nice SQL,
     * you could simply return parsedSql["delim"].
     * 
     * @param Json parsedSql The part of the output array, which contains the current expression.
     * @return a string, which is added right after the expression
     */
    protected auto getDelimiter(parsedSql) {
        return (parsedSql["delim"] == false ? "" : (parsedSql["delim"]) . " ").strip;
    }

    string build(Json parsedSql) {
        if (!isset(parsedSql["options"]) || parsedSql["options"] == false) {
            return "";
        }
        $options = parsedSql["options"];
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
