module langs.sql.sqlparsers.builders.create.tables.check;

import lang.sql;

@safe:

/**
 * Builds the CHECK statement part of CREATE TABLE. 
 * This class : the builder for the CHECK statement part of CREATE TABLE. 
 *  */
class CheckBuilder : ISqlBuilder {

    protected auto buildSelectBracketExpression(parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("CHECK")) {
            return "";
        }

        // Main
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= 
                buildReserved(myValue) ~
                buildSelectBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE check subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        return substr(mySql, 0, -1);
    }
}
