
/**
 * IndexSizeBuilder.php
 *
 * Builds index size part of a PRIMARY KEY statement part of CREATE TABLE.
 */

module langs.sql.PHPSQLParser.builders.index.size;

import lang.sql;

@safe:

/**
 * This class : the builder for the index size of a PRIMARY KEY
 * statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class IndexSizeBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }
    
    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX_SIZE) {
            return "";
        }
        auto mySql = "";
        foreach (myKey; myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildConstant(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE primary key index size subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
