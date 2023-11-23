module langs.sql.sqlparsers.builders.index.IndexCommentBuilder;

import lang.sql;

@safe:

/**
 * Builds index comment part of a CREATE INDEX statement. 
 * This class : the builder for the index comment of CREATE INDEX statement. 
 *  */
class IndexCommentBuilder : ISqlBuilder {

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilderr.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(COMMENT) {
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
}
