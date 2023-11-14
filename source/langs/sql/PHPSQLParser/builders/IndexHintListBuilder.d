
/**
 * IndexHintListBuilder.php
 *
 * Builds the index hint list of a table.

 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for index hint lists. 
 * You can overwrite all functions to achieve another handling.
 */
class IndexHintListBuilder : ISqlBuilder {

    auto hasHint($parsed) {
        return isset($parsed["hints"]);
    }

    // TODO: the hint list should be enhanced to get base_expr fro position calculation
    auto build(array $parsed) {
        if (!isset($parsed["hints"]) || $parsed["hints"] == false) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["hints"] as $k => $v) {
            mySql  ~= $v["hint_type"] . " "~ $v["hint_list"] . " ";
        }
        return " "~ substr(mySql, 0, -1);
    }
}
