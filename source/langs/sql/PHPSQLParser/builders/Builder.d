
/**
 * Builder.php
 *
 * Interface declaration for all builder classes.

 */

module lang.sql.parsers.builders;

/**
 * A builder can create a part of an SQL statement. The necessary information
 * are provided by the auto parameter as array. This array is a subtree
 * of the PHPSQLParser output.
 * 
 
 
 */
interface ISqlBuilder {
    /**
     * Builds a part of an SQL statement.
     * 
     * @param array $parsed a subtree of the PHPSQLParser output array
     * 
     * @return A string, which contains a part of an SQL statement.
     */
    auto build(array $parsed);
}

?>
