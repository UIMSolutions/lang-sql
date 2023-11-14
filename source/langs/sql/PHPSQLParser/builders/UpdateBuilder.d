
/**
 * UpdateBuilder.php
 *
 * Builds the UPDATE statement parts.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the UPDATE statement parts. 
 * You can overwrite all functions to achieve another handling.
 */
class UpdateBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $idx) {
        auto myBuilder = new TableBuilder();
        return $builder.build($parsed, $idx);
    }

    auto build(array $parsed) {
        auto mySql = "";

        foreach ($parsed as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildTable($v, $k);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('UPDATE table list', $k, $v, 'expr_type');
            }
        }
        return 'UPDATE ' . mySql;
    }
}
