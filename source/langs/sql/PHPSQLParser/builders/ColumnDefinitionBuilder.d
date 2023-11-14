
/**
 * ColumnDefinitionBuilder.php
 *
 * Builds the column definition statement part of CREATE TABLE.

 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the columndefinition statement part 
 * of CREATE TABLE. You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class ColumnDefinitionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnType($parsed) {
        $builder = new ColumnTypeBuilder();
        return $builder.build($parsed);
    }

   auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLDEF) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildColumnType($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
