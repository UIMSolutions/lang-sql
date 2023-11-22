module langs.sql.sqlparsers.builders.where;

import lang.sql;

@safe:

/**
 * Builds the WHERE part.
 * This class : the builder for the WHERE part.
 * You can overwrite all functions to achieve another handling.
 */
class WhereBuilder : ISqlBuilder {

    protected auto buildColRef(parsedSQL) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildOperator(parsedSQL) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildFunction(parsedSQL) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSubQuery(parsedSQL) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildInList(parsedSQL) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildWhereExpression(parsedSQL) {
        auto myBuilder = new WhereExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildWhereBracketExpression(parsedSQL) {
        auto myBuilder = new WhereBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildUserVariable(parsedSQL) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
      auto myBuilder = new ReservedBuilder();
      return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        mySql = "WHERE ";
        foreach (myKey, myValue; parsedSQL) {
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
