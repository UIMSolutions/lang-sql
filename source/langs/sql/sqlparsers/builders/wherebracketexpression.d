
module langs.sql.sqlparsers.builders.wherebracketexpression;

import lang.sql;

@safe:

/**
 * Builds bracket expressions within the WHERE part.
 * This class : the builder for bracket expressions within the WHERE part.
 * You can overwrite all functions to achieve another handling.
 */
class WhereBracketExpressionBuilder : ISqlBuilder {

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

    protected auto buildInList(parsedSQL) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildWhereExpression(parsedSQL) {
        auto myBuilder = new WhereExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildUserVariable(parsedSQL) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSubQuery(parsedSQL) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
      auto myBuilder = new ReservedBuilder();
      return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(BRACKET_EXPRESSION) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
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
