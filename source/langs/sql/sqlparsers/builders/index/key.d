module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds index key part of a CREATE TABLE statement.
 * This class : the builder for the index key part of a CREATE TABLE statement. 
 * You can overwrite all functions to achieve another handling. */
class IndexKeyBuilder : ISqlBuilder {

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildIndexType(parsedSQL) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildColumnList(parsedSQL) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(INDEX) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
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
}
