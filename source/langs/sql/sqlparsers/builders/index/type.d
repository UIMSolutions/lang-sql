module langs.sql.sqlparsers.builders.index.type;

import lang.sql;

@safe:

/**
 * Builds index type part of a PRIMARY KEY statement part of CREATE TABLE.
 * This class : the builder for the index type of a PRIMARY KEY
 * statement part of CREATE TABLE. 
 *  */
class IndexTypeBuilder : ISqlBuilder {

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(INDEX_TYPE) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE primary key index type subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
