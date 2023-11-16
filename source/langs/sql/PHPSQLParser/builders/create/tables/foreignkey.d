module langs.sql.PHPSQLParser.builders.create.tables.foreignkey;

import lang.sql;

@safe:

/**
 * Builds the FOREIGN KEY statement part of CREATE TABLE. 
 * This class : the builder for the FOREIGN KEY statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ForeignKeyBuilder : IBuilder {

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildForeignRef($parsed) {
        auto myBuilder = new ForeignRefBuilder();
        return myBuilder.build($parsed);
    }
    
    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::FOREIGN_KEY) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildColumnList(myValue);
            mySql  ~= this.buildForeignRef(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE foreign key subtree', myKey, myValue, "expr_type");
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
