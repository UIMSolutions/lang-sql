module langs.sql.sqlparsers.builders.create.tables.collation;

import langs.sql;

@safe:

// Builds the collation expression part of CREATE TABLE.
class CollationBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("COLLATE")) {
            return "";
        }

        string mySql = parsedSql["sub_tree"];
        return substr(mySql, 0, -1);
    }

    protected string buildKeyValue(string aKey, Json aValue) {
        string result;
        result ~= this.buildReserved(myValue);
        result ~= this.buildOperator(myValue);
        result ~= this.buildConstant(myValue);

        if (result.isEmpty) { // No change
            throw new UnableToCreateSQLException("CREATE TABLE options collation subtree", aKey, aValue, "expr_type");
        }

        result ~= " ";
        return result;
    }

    protected string buildOperator(Json parsedSql) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }
}
