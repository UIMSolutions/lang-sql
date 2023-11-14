
/**
 * CharacterSetBuilder.php
 *
 * Builds the CHARACTER SET part of a CREATE TABLE statement. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the CHARACTER SET statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class CharacterSetBuilder : ISqlBuilder {

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CHARSET) {
            return "";
        }
        
        auto mySql = "";
        foreach (k, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildConstant(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE options CHARACTER SET subtree', k, v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
