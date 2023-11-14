module source.langs.sql.PHPSQLParser.builders.create.tables.primarykey;

import lang.sql;

@safe:

/**
 * Builds the PRIMARY KEY statement part of CREATE TABLE. 
 * This class : the builder for the PRIMARY KEY  statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class PrimaryKeyBuilder : ISqlBuilder {

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstraint($parsed) {
        auto myBuilder = new ConstraintBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildIndexType($parsed) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildIndexSize($parsed) {
        auto myBuilder = new IndexSizeBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildIndexParser($parsed) {
        auto myBuilder = new IndexParserBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::PRIMARY_KEY) { return ""; }

        auto mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildConstraint(myValue);
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildColumnList(myValue);
            mySql  ~= this.buildIndexType(myValue);
            mySql  ~= this.buildIndexSize(myValue);
            mySql  ~= this.buildIndexParser(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', $k, myValue, "expr_type");
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
