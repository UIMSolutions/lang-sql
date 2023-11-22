module langs.sql.sqlparsers.builders.where;

import lang.sql;

@safe:

/**
 * Builds the WHERE part.
 * This class : the builder for the WHERE part.
 * You can overwrite all functions to achieve another handling.
 */
class WhereBuilder : ISqlBuilder {

    protected auto buildColRef(parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildOperator(parsedSql) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildFunction(parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSubQuery(parsedSql) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildInList(parsedSql) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildWhereExpression(parsedSql) {
        auto myBuilder = new WhereExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildWhereBracketExpression(parsedSql) {
        auto myBuilder = new WhereBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildUserVariable(parsedSql) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(parsedSql) {
      auto myBuilder = new ReservedBuilder();
      return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        mySql = "WHERE ";
        foreach (myKey, myValue; parsedSql) {
            size_t oldSqlLength = mySql.length;

            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildInList(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildWhereExpression(myValue);
            mySql ~= this.buildWhereBracketExpression(myValue);
            mySql ~= this.buildUserVariable(myValue);
            mySql ~= this.buildReserved(myValue);
            
            if (strlen(mySql) == $len) {
                throw new UnableToCreateSQLException("WHERE", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }

}
