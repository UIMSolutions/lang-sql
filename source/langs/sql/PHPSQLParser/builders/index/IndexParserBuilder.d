
/**
 * IndexParserBuilder.php
 *
 * Builds index parser part of a PRIMARY KEY statement part of CREATE TABLE.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the index parser of a PRIMARY KEY
 * statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class IndexParserBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX_PARSER) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildConstant($v);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key index parser subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
