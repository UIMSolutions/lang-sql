
module langs.sql.sqlparsers.builders.wherebracketexpression;

import lang.sql;

@safe:

/**
 * Builds bracket expressions within the WHERE part.
 * This class : the builder for bracket expressions within the WHERE part.
 * 
 */
class WhereBracketExpressionBuilder : ISqlBuilder {

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

    protected auto buildInList(parsedSql) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildWhereExpression(parsedSql) {
        auto myBuilder = new WhereExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildUserVariable(parsedSql) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSubQuery(parsedSql) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(parsedSql) {
      auto myBuilder = new ReservedBuilder();
      return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(BRACKET_EXPRESSION) {
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
            mySql ~= this.build(myValue);
            mySql ~= this.buildUserVariable(myValue);
           // mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildSubQuery(myValue);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("WHERE expression subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        mySql = "(" ~ substr(mySql, 0, -1) ~ ")";
        return mySql;
    }

}
