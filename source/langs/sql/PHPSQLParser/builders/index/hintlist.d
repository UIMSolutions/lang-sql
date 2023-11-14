
/**
 * IndexHintListBuilder.php
 *
 * Builds the index hint list of a table.
 */

module langs.sql.PHPSQLParser.builders.index.IndexHintListBuilder;

/**
 * This class : the builder for index hint lists. 
 * You can overwrite all functions to achieve another handling. */
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
        foreach ($parsed["hints"] as $k => myValue) {
            mySql  ~= myValue["hint_type"] . " "~ myValue["hint_list"] . " ";
        }
        return " "~ substr(mySql, 0, -1);
    }
}
