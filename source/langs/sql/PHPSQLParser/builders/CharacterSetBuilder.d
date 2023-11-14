
/**
 * CharacterSetBuilder.php
 *
 * Builds the CHARACTER SET part of a CREATE TABLE statement. * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the CHARACTER SET statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class CharacterSetBuilder : ISqlBuilder {

    protected auto buildConstant($parsed) {
        myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        myBuilder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CHARSET) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildConstant($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE options CHARACTER SET subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
