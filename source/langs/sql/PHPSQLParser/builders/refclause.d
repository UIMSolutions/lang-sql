module langs.sql.PHPSQLParser.builders.refclause;

import lang.sql;

@safe:

/**
 * Builds reference clauses within a JOIN.
 * This class : the references clause within a JOIN.
 * You can overwrite all functions to achieve another handling.
 */
class RefClauseBuilder : ISqlBuilder {

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if ($parsed.isEmpty) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; $parsed) {
            size_t oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildBracketExpression(myValue);
            mySql  ~= this.buildInList(myValue);
            mySql  ~= this.buildColumnList(myValue);
            mySql  ~= this.buildSubQuery(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('expression ref_clause', myKey, myValue, "expr_type");
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
