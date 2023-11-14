
/**
 * ForeignKeyBuilder.php
 *
 * Builds the FOREIGN KEY statement part of CREATE TABLE.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

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
        if ($parsed["expr_type"] != ExpressionType::FOREIGN_KEY) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildForeignRef($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE foreign key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
