module langs.sql.sqlparsers.builders.uniqueindex;

import lang.sql;

@safe:

/**
 * Builds index key part of a CREATE TABLE statement. */
* This class : the builder for the index key part of a CREATE TABLE statement.
    *  /
    class UniqueIndexBuilder : ISqlBuilder {

        protected string buildReserved(Json parsedSql) {
            auto myBuilder = new ReservedBuilder();
            return myBuilder.build(parsedSql);
        }

        protected string buildConstant(Json parsedSql) {
            auto myBuilder = new ConstantBuilder();
            return myBuilder.build(parsedSql);
        }

        protected string buildIndexType(Json parsedSql) {
            auto myBuilder = new IndexTypeBuilder();
            return myBuilder.build(parsedSql);
        }

        protected string buildColumnList(Json parsedSql) {
            auto myBuilder = new ColumnListBuilder();
            return myBuilder.build(parsedSql);
        }

        string build(Json parsedSql) {
            if (!parsedSql.isExpressionType("UNIQUE_IDX") {
                    return ""; }

                    string mySql = ""; foreach (myKey, myValue; parsedSql["sub_tree"]) {
                        size_t oldSqlLength = mySql.length; mySql ~= this.buildReserved(myValue);
                            mySql ~= this.buildColumnList(myValue); mySql ~= this.buildConstant(
                                myValue); mySql ~= this.buildIndexType(myValue); if (
                                oldSqlLength == mySql.length) { // No change
                                throw new UnableToCreateSQLException("CREATE TABLE unique-index key subtree", myKey, myValue, "expr_type");
                            }

                        mySql ~= " "; }
                        return substr(mySql, 0,  - 1); }
                        protected string buildKeyValue(string aKey, Json aValue) {
                            string result; return result; }
                        }
