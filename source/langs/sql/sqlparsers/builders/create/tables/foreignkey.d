module langs.sql.sqlparsers.builders.create.tables.foreignkey;

import lang.sql;

@safe:

/**
 * Builds the FOREIGN KEY statement part of CREATE TABLE. 
 * This class : the builder for the FOREIGN KEY statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ForeignKeyBuilder : IBuilder {

    protected auto buildConstant(parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildColumnList(parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildForeignRef(parsedSql) {
        auto myBuilder = new ForeignRefBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(FOREIGN_KEY) {
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
