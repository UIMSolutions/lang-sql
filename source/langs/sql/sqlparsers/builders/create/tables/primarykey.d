module langs.sql.sqlparsers.builders.create.tables.primarykey;

import lang.sql;

@safe:

/**
 * Builds the PRIMARY KEY statement part of CREATE TABLE. 
 * This class : the builder for the PRIMARY KEY  statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class PrimaryKeyBuilder : ISqlBuilder {

    protected auto buildColumnList(parsedSQL) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstraint(parsedSQL) {
        auto myBuilder = new ConstraintBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildIndexType(parsedSQL) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildIndexSize(parsedSQL) {
        auto myBuilder = new IndexSizeBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildIndexParser(parsedSQL) {
        auto myBuilder = new IndexParserBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(PRIMARY_KEY) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildConstraint(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildColumnList(myValue);
            mySql ~= this.buildIndexType(myValue);
            mySql ~= this.buildIndexSize(myValue);
            mySql ~= this.buildIndexParser(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE primary key subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
