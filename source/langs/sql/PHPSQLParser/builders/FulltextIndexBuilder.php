
/**
 * IndexKeyBuilder.php
 *
 * Builds index key part of a CREATE TABLE statement.
 */

module lang.sql.parsers.builders;
use PHPSQLParser\exceptions\UnableToCreateSQLException;
use PHPSQLParser\utils\ExpressionType;

/**
 * This class : the builder for the index key part of a CREATE TABLE statement. 
 * You can overwrite all functions to achieve another handling.
 */
class FulltextIndexBuilder : IBuilder {

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildIndexKey($parsed) {
        if ($parsed['expr_type'] !== ExpressionType::INDEX) {
            return "";
        }
        return $parsed['base_expr'];
    }
    
    protected auto buildColumnList($parsed) {
        $builder = new ColumnListBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed['expr_type'] !== ExpressionType::FULLTEXT_IDX) {
            return "";
        }
        $sql = "";
        foreach ($parsed['sub_tree'] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildColumnList($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildIndexKey($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE fulltext-index key subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
