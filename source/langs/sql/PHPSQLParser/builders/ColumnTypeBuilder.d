
/**
 * ColumnTypeBuilder.php
 *
 * Builds the column type statement part of CREATE TABLE.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the column type statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class ColumnTypeBuilder : ISqlBuilder {

    protected auto buildColumnTypeBracketExpression($parsed) {
        $builder = new ColumnTypeBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildDataType($parsed) {
        $builder = new DataTypeBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildDefaultValue($parsed) {
        $builder = new DefaultValueBuilder();
        return $builder.build($parsed);
    }

    protected auto buildCharacterSet($parsed) {
        if ($parsed["expr_type"] != ExpressionType::CHARSET) {
            return "";
        }
        return $parsed["base_expr"];
    }

    protected auto buildCollation($parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLLATE) {
            return "";
        }
        return $parsed["base_expr"];
    }

    protected auto buildComment($parsed) {
        if ($parsed["expr_type"] != ExpressionType::COMMENT) {
            return "";
        }
        return $parsed["base_expr"];
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_TYPE) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildDataType($v);
            $sql  ~= this.buildColumnTypeBracketExpression($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildDefaultValue($v);
            $sql  ~= this.buildCharacterSet($v);
            $sql  ~= this.buildCollation($v);
            $sql  ~= this.buildComment($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE column-type subtree', $k, $v, 'expr_type');
            }
    
            $sql  ~= " ";
        }
    
        return substr($sql, 0, -1);
    }
    
}
