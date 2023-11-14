
/**
 * IndexKeyBuilder.php
 *
 * Builds index key part of a CREATE TABLE statement.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the index key part of a CREATE TABLE statement. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class UniqueIndexBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildIndexType($parsed) {
        myBuilder = new IndexTypeBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildColumnList($parsed) {
        myBuilder = new ColumnListBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::UNIQUE_IDX) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildIndexType($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE unique-index key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
