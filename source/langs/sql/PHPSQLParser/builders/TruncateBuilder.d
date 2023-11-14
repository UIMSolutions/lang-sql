
/**
 * TruncateBuilder.php
 *
 * Builds the TRUNCATE statement
 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the [TRUNCATE] part. You can overwrite
 * all functions to achieve another handling.
 * 
 */
class TruncateBuilder : ISqlBuilder {

    auto build(array $parsed) {
        $sql = "TRUNCATE TABLE ";
        $right = -1;

        // works for one table only
        $parsed["tables"] = array($parsed["TABLE"]["base_expr"]);

        if ($parsed["tables"] != false) {
            foreach ($parsed["tables"] as $k => $v) {
                $sql  ~= $v . ", ";
                $right = -2;
            }
        }

        return substr($sql, 0, $right);
    }
}
