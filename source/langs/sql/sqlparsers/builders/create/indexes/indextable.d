module langs.sql.sqlparsers.builders.create.indexes.indextable;

import lang.sql;

@safe:
/**
 * Builds the table part of a CREATE INDEX statement */
 * This class : the builder for the table part of a CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling. */
class CreateIndexTableBuilder : ISqlBuilder {

    protected auto buildColumnList(parsedSQL) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL.isSet("on") || parsedSQL["on"] == false) {
            return "";
        }
        $table = parsedSQL["on"];
        if (!$table["expr_type"].isExpressionType("TABLE") {
            return "";
        }
        return "ON " ~ $table["name"] ~ " " ~ this.buildColumnList($table["sub_tree"]);
    }

}
