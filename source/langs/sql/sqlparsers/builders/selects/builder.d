module langs.sql.sqlparsers.builders.selects.builder;

import lang.sql;

@safe:

/**
 * Builds the SELECT statement from the [SELECT] field. 
 * This class : the builder for the [SELECT] field. You can overwrite
 * all functions to achieve another handling. */
class SelectBuilder : ISqlBuilder {

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildFunction(parsedSQL) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSelectExpression(parsedSQL) {
        auto myBuilder = new SelectExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSelectBracketExpression(parsedSQL) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildColRef(parsedSQL) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }
    /**
     * Returns a well-formatted delimiter string. If you don"t need nice SQL,
     * you could simply return parsedSQL["delim"].
     * 
     * @param Json parsedSQL The part of the output array, which contains the current expression.
     * @return a string, which is added right after the expression
     */
    protected auto getDelimiter(parsedSQL) {
        return (!parsedSQL.isSet("delim") || parsedSQL["delim"] == false ? "" : (parsedSQL["delim"]) ~ " ").strip;
    }

    string build(Json parsedSQL) {
        string mySql = "";
        foreach (myKey, myValue; parsedSQL) {
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
}
