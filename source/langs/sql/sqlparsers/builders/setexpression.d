module langs.sql.sqlparsers.builders.setexpression;

import lang.sql;

@safe:

// Builds the SET part of the INSERT statement. */
class SetExpressionBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("EXPRESSION")) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            string myDelim = " ";
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildBracketExpression(myValue);

            // we don"t need whitespace between the sign and 
            // the following part
            if (this.buildSign(myValue) != "") {
                myDelim = "";
            }
            mySql ~= this.buildSign(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("SET expression subtree", myKey, myValue, "expr_type");
            }

            mySql ~= myDelim;
        }
        mySql = substr(mySql, 0, -1);
        return mySql;
    }

    protected auto buildColRef(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(Json parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildOperator(Json parsedSql) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildFunction(Json parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildBracketExpression(Json parsedSql) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSign(Json parsedSql) {
        auto myBuilder = new SignBuilder();
        return myBuilder.build(parsedSql);
    }
}
