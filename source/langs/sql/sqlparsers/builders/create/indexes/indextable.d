module langs.sql.sqlparsers.builders.create.indexes.indextable;

import lang.sql;

@safe:
/**
 * Builds the table part of a CREATE INDEX statement */
 * This class : the builder for the table part of a CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling. */
class CreateIndexTableBuilder : ISqlBuilder {

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }

    string build(auto[string] parsedSQL) {
        if ($parsed.isSet("on") || $parsed["on"] == false) {
            return "";
        }
        $table = $parsed["on"];
        if (!$table["expr_type"].isExpressionType("TABLE") {
            return "";
        }
        return "ON " ~ $table["name"] ~ " " ~ this.buildColumnList($table["sub_tree"]);
    }

}
