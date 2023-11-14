
/**
 * LikeBuilder.php
 *
 * Builds the LIKE statement part of a CREATE TABLE statement.

 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the LIKE statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class LikeBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $index) {
        $builder = new TableBuilder();
        return $builder.build($parsed, $index);
    }

    auto build(array $parsed) {
        $sql = this.buildTable($parsed, 0);
        if (strlen($sql) == 0) {
            throw new UnableToCreateSQLException('LIKE', "", $parsed, 'table');
        }
        return "LIKE " . $sql;
    }
}
