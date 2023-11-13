
/**
 * CollationBuilder.php
 *
 * Builds the collation expression part of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the collation statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class CollationBuilder : ISqlBuilder {

    protected auto buildOperator($parsed) {
        $builder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] !== ExpressionType::COLLATE) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildConstant($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE options collation subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
