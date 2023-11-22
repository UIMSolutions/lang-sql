
module langs.sql.sqlparsers.builders.uniqueindex;

import lang.sql;

@safe:

/**
 * Builds index key part of a CREATE TABLE statement. */
 * This class : the builder for the index key part of a CREATE TABLE statement. 
 *  */
class UniqueIndexBuilder : ISqlBuilder {

    protected auto buildReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildIndexType(parsedSql) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildColumnList(parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("UNIQUE_IDX") {
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
                throw new UnableToCreateSQLException("CREATE TABLE unique-index key subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
