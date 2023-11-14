
/**
 * ReplaceColumnListBuilder.php
 *
 * Builds column-list parts of REPLACE statements.

 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for column-list parts of REPLACE statements. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class ReplaceColumnListBuilder : ISqlBuilder {

    protected auto buildColumn($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_LIST) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildColumn($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('REPLACE column-list subtree', $k, $v, 'expr_type');
            }

            $sql  ~= ", ";
        } 
        return "(" . substr($sql, 0, -2) . ")";
    }

}
