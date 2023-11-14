
/**
 * PrimaryKeyBuilder.php
 *
 * Builds the PRIMARY KEY statement part of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the PRIMARY KEY  statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class PrimaryKeyBuilder : ISqlBuilder {

    protected auto buildColumnList($parsed) {
        $builder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstraint($parsed) {
        $builder = new ConstraintBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexType($parsed) {
        $builder = new IndexTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexSize($parsed) {
        $builder = new IndexSizeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexParser($parsed) {
        $builder = new IndexParserBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::PRIMARY_KEY) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildConstraint($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildColumnList($v);
            $sql  ~= this.buildIndexType($v);
            $sql  ~= this.buildIndexSize($v);
            $sql  ~= this.buildIndexParser($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
