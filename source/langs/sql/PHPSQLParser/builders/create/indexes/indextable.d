
/**
 * CreateIndexTable.php
 *
 * Builds the table part of a CREATE INDEX statement */

module source.langs.sql.PHPSQLParser.builders.create.indexes.indextable;

import lang.sql;

@safe:
/**
 * This class : the builder for the table part of a CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling. */
class CreateIndexTableBuilder : ISqlBuilder {

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if (!isset($parsed["on"]) || $parsed["on"] == false) {
            return "";
        }
        $table = $parsed["on"];
        if ($table["expr_type"] != ExpressionType::TABLE) {
            return "";
        }
        return "ON " ~ $table["name"] ~ " " ~ this.buildColumnList($table["sub_tree"]);
    }

}
