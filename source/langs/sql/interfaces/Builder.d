module langs.sql.interfaces.Builder;

import lang.sql;

@safe:
/**
 * Interface declaration for all builder classes.
 * A builder can create a part of an SQL statement. The necessary information
 * are provided by the auto parameter as array. This array is a subtree
 * of the SqlParser output.
 */
interface ISqlBuilder {
  /**
     * Builds a part of an SQL statement.
     * @param array $parsed a subtree of the SqlParser output array
     * returns part of an SQL statement.
     */
  string build(array $parsed);
}
