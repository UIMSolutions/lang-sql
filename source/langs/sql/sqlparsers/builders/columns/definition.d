module langs.sql.sqlparsers.builders.columns.definition;

import lang.sql;

@safe:
/**
 * Builds the column definition statement part of CREATE TABLE. 
 * This class : the builder for the columndefinition statement part 
 * of CREATE TABLE. You can overwrite all functions to achieve another handling. */
class ColumnDefinitionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColumnType($parsed) {
        auto myBuilder = new ColumnTypeBuilder();
        return myBuilder.build($parsed);
    }

   string build(array $parsed) {
        // In Check
        if (!$parsed["expr_type"].isExpressionType("COLDEF")) {
            return "";
        }

        // Main
        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildColumnType(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        return substr(mySql, 0, -1);
    }
}