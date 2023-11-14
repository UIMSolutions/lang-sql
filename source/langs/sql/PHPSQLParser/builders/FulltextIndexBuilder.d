
/**
 * IndexKeyBuilder.php
 *
 * Builds index key part of a CREATE TABLE statement.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the index key part of a CREATE TABLE statement. 
 * You can overwrite all functions to achieve another handling.
 */
class FulltextIndexBuilder : IBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildIndexKey($parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX) {
            return "";
        }
        return $parsed["base_expr"];
    }
    
    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::FULLTEXT_IDX) {
            return "";
        }
        auto mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"] as $k => myValue) {
            $len = mySql.length;
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildColumnList(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildIndexKey(myValue);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('CREATE TABLE fulltext-index key subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
