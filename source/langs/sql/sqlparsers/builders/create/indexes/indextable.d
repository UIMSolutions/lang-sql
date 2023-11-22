module langs.sql.sqlparsers.builders.create.indexes.indextable;

import lang.sql;

@safe:
/**
 * Builds the table part of a CREATE INDEX statement */
 * This class : the builder for the table part of a CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling. */
class CreateIndexTableBuilder : ISqlBuilder {

    protected auto buildColumnList(parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql.isSet("on") || parsedSql["on"] == false) {
            return "";
        }
        $table = parsedSql["on"];
        if (!$table["expr_type"].isExpressionType("TABLE") {
            return "";
        }
        return "ON " ~ $table["name"] ~ " " ~ this.buildColumnList($table["sub_tree"]);
    }

}
