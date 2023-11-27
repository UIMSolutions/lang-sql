module langs.sql.sqlparsers.builders.create.tables.size;

import lang.sql;

@safe:

/**
 * Builds index size part of a PRIMARY KEY statement part of CREATE TABLE.
 * This class : the builder for the index size of a PRIMARY KEY
 * statement part of CREATE TABLE. 
 */
class IndexSizeBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("INDEX_SIZE") {
                return ""; }

                string mySql = ""; foreach (myKey; myValue; parsedSql["sub_tree"]) {
                    size_t oldSqlLength = mySql.length; mySql ~= this.buildReserved(myValue);
                        mySql ~= this.buildConstant(myValue); if (oldSqlLength == mySql.length) { // No change
                            throw new UnableToCreateSQLException("CREATE TABLE primary key index size subtree", myKey, myValue, "expr_type");
                        }

                    mySql ~= " "; }
                    return substr(mySql, 0,  - 1); }
                    protected string buildReserved(Json parsedSql) {
                        auto myBuilder = new ReservedBuilder(); return myBuilder.build(parsedSql);
                    }

                    protected string buildConstant(Json parsedSql) {
                        auto myBuilder = new ConstantBuilder(); return myBuilder.build(parsedSql);
                    }
                }
