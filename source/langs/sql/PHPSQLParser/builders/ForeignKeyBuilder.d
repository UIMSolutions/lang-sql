
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
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildForeignRef($parsed) {
        auto myBuilder = new ForeignRefBuilder();
        return myBuilder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::FOREIGN_KEY) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildForeignRef($v);

            if (oldSqlLength == mySql.length) {
                throw new UnableToCreateSQLException('CREATE TABLE foreign key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
