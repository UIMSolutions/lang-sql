
/**
 * CreateIndexTable.php
 *
 * Builds the table part of a CREATE INDEX statement */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for the table part of a CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling.
 */
class CreateIndexTableBuilder : ISqlBuilder {

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if (!isset($parsed["on"]) || $parsed["on"] == false) {
            return "";
        }
        $table = $parsed["on"];
        if ($table["expr_type"] != ExpressionType::TABLE) {
            return "";
        }
        return 'ON ' . $table["name"] . ' ' . this.buildColumnList($table["sub_tree"]);
    }

}
