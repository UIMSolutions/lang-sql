module langs.sql.sqlparsers.builders.create.tables.characterset;

import lang.sql;

@safe:

/**
 * Builds the CHARACTER SET part of a CREATE TABLE statement. */
 * This class : the builder for the CHARACTER SET statement part of CREATE TABLE. 
 */
class CharacterSetBuilder : ISqlBuilder {

    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildOperator(Json parsedSql) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("CHARSET")) {
            return "";
        }
        
        string mySql = "";
        foreach (k, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildConstant(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE options CHARACTER SET subtree", k, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
