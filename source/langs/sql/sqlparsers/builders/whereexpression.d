module langs.sql.sqlparsers.builders.whereexpression;

import lang.sql;

@safe:

/**
 * Builds expressions within the WHERE part.
 * This class : the builder for expressions within the WHERE part.
 */
class WhereExpressionBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("EXPRESSION")) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildInList(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildWhereExpression(myValue);
            mySql ~= this.buildWhereBracketExpression(myValue);
            mySql ~= this.buildUserVariable(myValue);
            mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildReserved(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("WHERE expression subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }

    protected string buildColRef(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildOperator(Json parsedSql) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildFunction(Json parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildInList(Json parsedSql) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildWhereExpression(Json parsedSql) {
        return this.build(parsedSql);
    }

    protected string buildWhereBracketExpression(Json parsedSql) {
        auto myBuilder = new WhereBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildUserVariable(Json parsedSql) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSubQuery(Json parsedSql) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }
}
