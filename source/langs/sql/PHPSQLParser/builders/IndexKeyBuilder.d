
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
 * 
 */
class IndexKeyBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildIndexType($parsed) {
        $builder = new IndexTypeBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildColumnList($parsed) {
        $builder = new ColumnListBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildColumnList($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildIndexType($v);            

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE index key subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
