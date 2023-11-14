
/**
 * LimitBuilder.php
 *
 * Builds the LIMIT statement.

 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder LIMIT statement. 
 * You can overwrite all functions to achieve another handling.
 */
class LimitBuilder : ISqlBuilder {

    auto build(array $parsed) {
        mySql = ($parsed["rowcount"]) . ($parsed["offset"] ? " OFFSET " . $parsed["offset"] : "");
        if (mySql == "") {
            throw new UnableToCreateSQLException('LIMIT', 'rowcount', $parsed, 'rowcount');
        }
        return "LIMIT " . mySql;
    }
}
