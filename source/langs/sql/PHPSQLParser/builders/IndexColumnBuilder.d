
/**
 * IndexColumnBuilder.php
 *
 * Builds the column entries of the column-list parts of CREATE TABLE.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for index column entries of the column-list 
 * parts of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class IndexColumnBuilder : ISqlBuilder {

    protected auto buildLength($parsed) {
        return ($parsed == false ? '' : ('(' . $parsed . ')'));
    }

    protected auto buildDirection($parsed) {
        return ($parsed == false ? '' : (' ' . $parsed));
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX_COLUMN) {
            return "";
        }
        $sql = $parsed["name"];
        $sql  ~= this.buildLength($parsed["length"]);
        $sql  ~= this.buildDirection($parsed["dir"]);
        return $sql;
    }

}
