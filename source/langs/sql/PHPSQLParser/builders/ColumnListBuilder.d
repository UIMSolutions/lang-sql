
/**
 * ColumnListBuilder.php
 *
 * Builds column-list parts of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for column-list parts of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class ColumnListBuilder : ISqlBuilder {

    protected auto buildIndexColumn($parsed) {
        $builder = new IndexColumnBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnReference($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed, $delim = ', ') {
        if ($parsed["expr_type"] !== ExpressionType::COLUMN_LIST) {
            return '';
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildIndexColumn($v);
            $sql  ~= this.buildColumnReference($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE column-list subtree', $k, $v, 'expr_type');
            }

            $sql  ~= $delim;
        }
        return '(' . substr($sql, 0, -strlen($delim)) . ')';
    }

}
