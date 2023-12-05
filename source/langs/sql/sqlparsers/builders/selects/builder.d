module langs.sql.sqlparsers.builders.selects.builder;

import lang.sql;

@safe:

// Builds the SELECT statement from the [SELECT] field. 
class SelectBuilder : ISqlBuilder {

    /**
     * Returns a well-formatted delimiter string. If you don"t need nice SQL,
     * you could simply return parsedSql["delim"].
     * 
     * @param Json parsedSql The part of the output array, which contains the current expression.
     * @return a string, which is added right after the expression
     */
    protected auto getDelimiter(Json parsedSql) {
        return (!parsedSql.isSet("delim") || parsedSql["delim"].isEmpty ? "" : (
                parsedSql["delim"]) ~ " ").strip;
    }

    string build(Json parsedSql) {
        string mySql = "";
        foreach (myKey, myValue; parsedSql) {
            size_t oldSqlLength = mySql.length;
           mySql ~= this.buildColRef(myValue);
           mySql ~= this.buildSelectBracketExpression(myValue);
           mySql ~= this.buildSelectExpression(myValue);
           mySql ~= this.buildFunction(myValue);
           mySql ~= this.buildConstant(myValue);
           mySql ~= this.buildReserved(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("SELECT", myKey, myValue, "expr_type");
            }

           mySql ~= this.getDelimiter(myValue);
        }
        return "SELECT " ~ mySql;
    }
    protected string buildKeyValue(string aKey, Json aValue) {
        string result;
        return result;
    }
    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildFunction(Json parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSelectExpression(Json parsedSql) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSelectBracketExpression(Json parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildColRef(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }
}
