module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds index key part of a CREATE TABLE statement.
 * This class : the builder for the index key part of a CREATE TABLE statement. 
 */
class IndexKeyBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("INDEX")) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildColumnList(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildIndexType(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE index key subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildIndexType(Json parsedSql) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }
}
