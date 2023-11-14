
/**
 * TruncateBuilder.php
 *
 * Builds the TRUNCATE statement */

module langs.sql.PHPSQLParser.builders.truncate;

/**
 * This class : the builder for the [TRUNCATE] part. You can overwrite
 * all functions to achieve another handling. */
class TruncateBuilder : ISqlBuilder {

    string build(array $parsed) {
        auto mySql = "TRUNCATE TABLE ";
        $right = -1;

        // works for one table only
        $parsed["tables"] = array($parsed["TABLE"]["base_expr"]);

        if ($parsed["tables"] != false) {
            foreach (myKey, myValue; $parsed["tables"]) {
                mySql  ~= myValue ~ ", ";
                $right = -2;
            }
        }

        return substr(mySql, 0, $right);
    }
}
