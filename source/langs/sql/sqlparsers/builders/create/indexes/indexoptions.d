module langs.sql.sqlparsers.builders.create.indexes.indexoptions;

import lang.sql;

@safe:
/**
 * Builds index options part of a CREATE INDEX statement.
 * This class : the builder for the index options of a CREATE INDEX
 * statement. 
 */
class CreateIndexOptionsBuilder : ISqlBuilder {

    protected string buildIndexParser(Json parsedSql) {
        auto myBuilder = new IndexParserBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexSize(Json parsedSql) {
        auto myBuilder = new IndexSizeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexType(Json parsedSql) {
        auto myBuilder = new IndexTypeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexComment(Json parsedSql) {
        auto myBuilder = new IndexCommentBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexAlgorithm(Json parsedSql) {
        auto myBuilder = new IndexAlgorithmBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildIndexLock(Json parsedSql) {
        auto myBuilder = new IndexLockBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["options"] == false) {
            return "";
        }
        
        string mySql = "";
        foreach (myKey, myValue; parsedSql["options"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildIndexAlgorithm(myValue);
            mySql ~= this.buildIndexLock(myValue);
            mySql ~= this.buildIndexComment(myValue);
            mySql ~= this.buildIndexParser(myValue);
            mySql ~= this.buildIndexSize(myValue);
            mySql ~= this.buildIndexType(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE INDEX options", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return " " ~ substr(mySql, 0, -1);
    }
}
