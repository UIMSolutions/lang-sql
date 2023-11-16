
/**
 * CheckBuilder.php
 *
 * Builds the CHECK statement part of CREATE TABLE. */

module langs.sql.PHPSQLParser.builders.create.tables.check;

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

    string build(array $parsed) {
        if ($parsed["expr_type"] !.isExpressionType(CHECK) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildSelectBracketExpression(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE check subtree', myKey, myValue, "expr_type");
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
