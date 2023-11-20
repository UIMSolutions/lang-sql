module langs.sql.sqlparsers.builders.subtree;

import lang.sql;

@safe:

/**
 * Builds the statements for [sub_tree] fields.
 * This class : the builder for [sub_tree] fields.
 * You can overwrite all functions to achieve another handling.
 */
class SubTreeBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildQuery($parsed) {
        auto myBuilder = new QueryBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSelectBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSign($parsed) {
        auto myBuilder = new SignBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed, $delim = " ") {
        if ($parsed["sub_tree"].isEmpty || $parsed["sub_tree"] == false) {
            return "";
        }
        
        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildInList(myValue);
            mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildSelectBracketExpression(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildQuery(myValue);
            mySql ~= this.buildUserVariable(myValue);

            string mySign = this.buildSign(myValue);
            mySql ~= mySign;

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("expression subtree", myKey, myValue, "expr_type");
            }

            // We don"t need whitespace between a sign and the following part.
            if (mySign.isEmpty) {
                mySql ~= $delim;
            }
        }
        return substr(mySql, 0, -strlen($delim));
    }
}
