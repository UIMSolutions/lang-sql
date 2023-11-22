module langs.sql.sqlparsers.builders.create.tables.collation;

import lang.sql;

@safe:

/**
 * Builds the collation expression part of CREATE TABLE.
 * This class : the builder for the collation statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CollationBuilder : ISqlBuilder {

    protected auto buildOperator(parsedSql) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(COLLATE) { return ""; }

        string mySql = "";
        foreach (key, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildConstant(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE options collation subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
