
/**
 * SetBuilder.php
 *
 * Builds the SET part of the INSERT statement.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the SET part of INSERT statement. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class SetBuilder : ISqlBuilder {

    protected auto buildSetExpression($parsed) {
        myBuilder = new SetExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildSetExpression($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('SET', $k, $v, 'expr_type');
            }

            mySql  ~= ",";
        }
        return "SET " . substr(mySql, 0, -1);
    }
}
