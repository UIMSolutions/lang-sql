module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds index key part of a CREATE TABLE statement.
 * This class : the builder for the index key part of a CREATE TABLE statement. 
 * You can overwrite all functions to achieve another handling. */
class IndexKeyBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildIndexType($parsed) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }
    
    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildColumnList(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildIndexType(myValue);            

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE index key subtree', myKey, myValue, "expr_type");
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
