
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
        $builder = new SetExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildSetExpression($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('SET', $k, $v, 'expr_type');
            }

            $sql  ~= ",";
        }
        return "SET " . substr($sql, 0, -1);
    }
}
