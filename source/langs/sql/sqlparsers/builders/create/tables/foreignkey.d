module langs.sql.sqlparsers.builders.create.tables.foreignkey;

import lang.sql;

@safe:

/**
 * Builds the FOREIGN KEY statement part of CREATE TABLE. 
 * This class : the builder for the FOREIGN KEY statement part of CREATE TABLE. 
 */
class ForeignKeyBuilder : IBuilder {

    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildForeignRef(Json parsedSql) {
        auto myBuilder = new ForeignRefBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(FOREIGN_KEY) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildColumnList(myValue);
            mySql ~= this.buildForeignRef(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE foreign key subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
