
module langs.sql.sqlparsers.builders.create.tables.foreignref;

import lang.sql;

@safe:

// Builds the FOREIGN KEY REFERENCES statement part of CREATE TABLE. */
class ForeignRefBuilder : ISqlBuilder {

    protected string buildTable(Json parsedSql) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, 0);
    }

    protected string buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(REFERENCE) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
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
