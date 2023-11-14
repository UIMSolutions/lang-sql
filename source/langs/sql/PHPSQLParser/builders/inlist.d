
/**
 * InListBuilder.php
 *
 * Builds lists of values for the IN statement.
 */

module source.langs.sql.PHPSQLParser.builders.inlist;

import lang.sql;

@safe:

/**
 * This class : the builder list of values for the IN statement. 
 * You can overwrite all functions to achieve another handling. */
class InListBuilder : ISqlBuilder {

    protected auto buildSubTree($parsed, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return myBuilder.build($parsed, $delim);
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::IN_LIST) {
            return "";
        }
        $sql = this.buildSubTree($parsed, ", ");
        return "(" . $sql . ")";
    }
}
