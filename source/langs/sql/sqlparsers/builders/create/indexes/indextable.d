module langs.sql.sqlparsers.builders.create.indexes.indextable;

import lang.sql;

@safe:
// Builds the table part of a CREATE INDEX statement
class CreateIndexTableBuilder : ISqlBuilder {



    string build(Json parsedSql) {
        if (parsedSql.isSet("on") || parsedSql["on"] == false) {
            return "";
        }
        auto tableSql = parsedSql["on"];
        if (!tableSql.isExpressionType("TABLE")) {
            return "";
        }
        return "ON %s %s".format(tableSql["name"], this.buildColumnList(tableSql["sub_tree"]));
    }
    protected string buildColumnList(Json parsedSql) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSql);
    }
}
