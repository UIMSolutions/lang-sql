
/**
 * SetBuilder.php
 *
 * Builds the SET part of the INSERT statement. */

module source.langs.sql.PHPSQLParser.builders.set;

import lang.sql;

@safe:

/**
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling. */
class SetBuilder : ISqlBuilder {

    protected auto buildSetExpression($parsed) {
        auto myBuilder = new SetExpressionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildSetExpression($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('SET', $k, $v, 'expr_type');
            }

            mySql  ~= ",";
        }
        return "SET " . substr(mySql, 0, -1);
    }
}