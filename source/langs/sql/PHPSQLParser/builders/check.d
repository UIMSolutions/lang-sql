
/**
 * CheckBuilder.php
 *
 * Builds the CHECK statement part of CREATE TABLE. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the CHECK statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class CheckBuilder : ISqlBuilder {

    protected auto buildSelectBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CHECK) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildSelectBracketExpression($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE check subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
