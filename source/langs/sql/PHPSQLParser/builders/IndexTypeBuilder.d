
/**
 * IndexTypeBuilder.php
 *
 * Builds index type part of a PRIMARY KEY statement part of CREATE TABLE.

 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the index type of a PRIMARY KEY
 * statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class IndexTypeBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX_TYPE) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildReserved($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key index type subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
