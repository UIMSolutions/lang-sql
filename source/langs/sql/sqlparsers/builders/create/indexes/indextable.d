module langs.sql.sqlparsers.builders.create.indexes.indextable;

import lang.sql;

@safe:
/**
 * Builds the table part of a CREATE INDEX statement */
 * This class : the builder for the table part of a CREATE INDEX statement. 
 */
class CreateIndexTableBuilder : ISqlBuilder {

    protected string buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql.isSet("on") || parsedSql["on"] == false) {
            return "";
        }
        $table = parsedSql["on"];
        if (!$table.isExpressionType("TABLE") {
            return "";
        }
        return "ON " ~ $table["name"] ~ " " ~ this.buildColumnList($table["sub_tree"]);
    }

}
