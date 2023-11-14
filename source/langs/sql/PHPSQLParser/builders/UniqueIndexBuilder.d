
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
class UniqueIndexBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildIndexType($parsed) {
        auto myBuilder = new IndexTypeBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::UNIQUE_IDX) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildIndexType($v);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('CREATE TABLE unique-index key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
