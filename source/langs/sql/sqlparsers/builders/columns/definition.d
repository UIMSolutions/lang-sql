module langs.sql.sqlparsers.builders.columns.definition;

import lang.sql;

@safe:
/**
 * Builds the column definition statement part of CREATE TABLE. 
 * This class : the builder for the columndefinition statement part 
 * of CREATE TABLE.  */
class ColumnDefinitionBuilder : ISqlBuilder {

    protected auto buildColRef(parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildColumnType(parsedSql) {
        auto myBuilder = new ColumnTypeBuilder();
        return myBuilder.build(parsedSql);
    }

   string build(Json parsedSql) {
        // In Check
        if (!parsedSql.isExpressionType("COLDEF")) {
            return "";
        }

        // Main
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildColumnType(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE primary key subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        return substr(mySql, 0, -1);
    }
}
