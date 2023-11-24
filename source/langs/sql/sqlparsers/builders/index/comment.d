module langs.sql.sqlparsers.builders.index.IndexCommentBuilder;

import lang.sql;

@safe:

// Builds index comment part of a CREATE INDEX statement. 
class IndexCommentBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("COMMENT")) {
            return "";
        }
        string mySql = "";
        foreach (parsedSql["sub_tree"] as myKey, myValue) {
            size_t oldSqlLength = mySql.length;

            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildConstant(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE INDEX comment subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilderr.build(parsedSql);
    }
}
