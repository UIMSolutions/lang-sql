
/**
 * ForeignRefBuilder.php
 *
 * Builds the FOREIGN KEY REFERENCES statement part of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the FOREIGN KEY REFERENCES statement
 * part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class ForeignRefBuilder : ISqlBuilder {

    protected auto buildTable($parsed) {
        $builder = new TableBuilder();
        return $builder.build($parsed, 0);
    }

    protected auto buildColumnList($parsed) {
        $builder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::REFERENCE) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildTable($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildColumnList($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE foreign ref subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
