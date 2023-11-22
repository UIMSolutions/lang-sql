
module langs.sql.sqlparsers.builders.create.tables.foreignref;

import lang.sql;

@safe:

/**
 * Builds the FOREIGN KEY REFERENCES statement part of CREATE TABLE. */
 * This class : the builder for the FOREIGN KEY REFERENCES statement
 * part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ForeignRefBuilder : ISqlBuilder {

    protected auto buildTable(parsedSQL) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSQL, 0);
    }

    protected auto buildColumnList(parsedSQL) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(REFERENCE) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildTable(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildColumnList(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE foreign ref subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
