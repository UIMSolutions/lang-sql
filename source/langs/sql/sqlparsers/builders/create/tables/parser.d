module langs.sql.sqlparsers.builders.create.tables.parser;

import lang.sql;

@safe:

/**
 * Builds index parser part of a PRIMARY KEY statement part of CREATE TABLE.
 * This class : the builder for the index parser of a PRIMARY KEY
 * statement part of CREATE TABLE. 
 *  */
class IndexParserBuilder : ISqlBuilder {

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(INDEX_PARSER) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValie; parsedSql["sub_tree"]) {
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
