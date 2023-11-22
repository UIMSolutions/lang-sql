module langs.sql.sqlparsers.builders.refclause;

import lang.sql;

@safe:

/**
 * Builds reference clauses within a JOIN.
 * This class : the references clause within a JOIN.
 * You can overwrite all functions to achieve another handling.
 */
class RefClauseBuilder : ISqlBuilder {

    protected auto buildInList(parsedSQL) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildColRef(parsedSQL) {
        auto myBuilder = new ColumnReferenceBuilder();
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

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildBracketExpression(parsedSQL) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildColumnList(parsedSQL) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSubQuery(parsedSQL) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL.isEmpty) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSQL) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildBracketExpression(myValue);
            mySql ~= this.buildInList(myValue);
            mySql ~= this.buildColumnList(myValue);
            mySql ~= this.buildSubQuery(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("expression ref_clause", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
