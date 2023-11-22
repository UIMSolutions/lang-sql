module langs.sql.sqlparsers.builders.index.IndexCommentBuilder;

import lang.sql;

@safe:

/**
 * Builds index comment part of a CREATE INDEX statement. 
 * This class : the builder for the index comment of CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling. */
class IndexCommentBuilder : ISqlBuilder {

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilderr.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(COMMENT) {
            return "";
        }
        string mySql = "";
        foreach (parsedSQL["sub_tree"] as myKey, myValue) {
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
