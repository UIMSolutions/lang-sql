
/**
 * ForeignRefBuilder.php
 *
 * Builds the FOREIGN KEY REFERENCES statement part of CREATE TABLE. */

module source.langs.sql.PHPSQLParser.builders.create.tables.foreignref;

import lang.sql;

@safe:

/**
 * This class : the builder for the FOREIGN KEY REFERENCES statement
 * part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ForeignRefBuilder : ISqlBuilder {

    protected auto buildTable($parsed) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, 0);
    }

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::REFERENCE) {
            return "";
        }
        auto mySql = "";
        foreach ($k :  myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildTable(myValue);
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildColumnList(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE foreign ref subtree', $k, myValue, "expr_type");
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
