module langs.sql.sqlparsers.builders.create.tables.parser;

import lang.sql;

@safe:

/**
 * Builds index parser part of a PRIMARY KEY statement part of CREATE TABLE.
 * This class : the builder for the index parser of a PRIMARY KEY
 * statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class IndexParserBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }
    
    string build(Json parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(INDEX_PARSER) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValie; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildConstant(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE primary key index parser subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
