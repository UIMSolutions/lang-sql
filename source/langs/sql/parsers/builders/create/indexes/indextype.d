module langs.sql.sqlparsers.builders.create.indexes.indextype;

import langs.sql;

@safe:
// Builds index type part of a CREATE INDEX statement. 
class CreateIndexTypeBuilder : IndexTypeBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isSet("index-type") || parsedSql["index-type"].isEmpty) {
            return "";
        }
        return super.build(parsedSql["index-type"]);
    }
}
