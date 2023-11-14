
/**
 * UpdateBuilder.php
 *
 * Builds the UPDATE statement parts. */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the UPDATE statement parts. 
 * You can overwrite all functions to achieve another handling. */
class UpdateBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $idx) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, $idx);
    }

    auto build(array $parsed) {
        auto mySql = "";

        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildTable($v, $k);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('UPDATE table list', $k, $v, 'expr_type');
            }
        }
        return 'UPDATE ' . mySql;
    }
}