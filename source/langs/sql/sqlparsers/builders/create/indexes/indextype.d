module langs.sql.sqlparsers.builders.create.indexes.indextype;

import lang.sql;

@safe:
/**
 * Builds index type part of a CREATE INDEX statement. 
 * This class : the builder for the index type of a CREATE INDEX
 * statement. 
 *  */
class CreateIndexTypeBuilder : IndexTypeBuilder {

    string build(Json parsedSql) {
        if (!parsedSql["index-type"]) || parsedSql["index-type"] == false) {
            return "";
        }
        return super.build(parsedSql["index-type"]);
    }
}
