
/**
 * SetBuilder.php
 *
 * Builds the SET part of the INSERT statement.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling.
 */
class SetBuilder : ISqlBuilder {

    protected auto buildSetExpression($parsed) {
        auto myBuilder = new SetExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildSetExpression($v);

            if (oldSqlLength == mySql.length) {
                throw new UnableToCreateSQLException('SET', $k, $v, 'expr_type');
            }

            mySql  ~= ",";
        }
        return "SET " . substr(mySql, 0, -1);
    }
}
