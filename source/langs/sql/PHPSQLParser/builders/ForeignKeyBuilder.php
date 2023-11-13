
/**
 * ForeignKeyBuilder.php
 *
 * Builds the FOREIGN KEY statement part of CREATE TABLE.
 *
 *
 * LICENSE:
 * Copyright (c) 2010-2014 Justin Swanhart and André Rothe
 * All rights reserved.
 *
 * 
 */

module lang.sql.parsers.builders;
use PHPSQLParser\exceptions\UnableToCreateSQLException;
use PHPSQLParser\utils\ExpressionType;

/**
 * This class : the builder for the FOREIGN KEY statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class ForeignKeyBuilder : IBuilder {

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        $builder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildForeignRef($parsed) {
        $builder = new ForeignRefBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] !== ExpressionType::FOREIGN_KEY) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildColumnList($v);
            $sql  ~= this.buildForeignRef($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE foreign key subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }
}
