module langs.sql.sqlparsers.builders.create.tables.primarykey;

import lang.sql;

@safe:

/**
 * Builds the PRIMARY KEY statement part of CREATE TABLE. 
class PrimaryKeyBuilder : ISqlBuilder {



    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(PRIMARY_KEY) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
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
        protected string buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildConstraint(Json parsedSql) {
        auto myBuilder = new ConstraintBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexType(Json parsedSql) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexSize(Json parsedSql) {
        auto myBuilder = new IndexSizeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexParser(Json parsedSql) {
        auto myBuilder = new IndexParserBuilder();
        return myBuilder.build(parsedSql);
    }
}
