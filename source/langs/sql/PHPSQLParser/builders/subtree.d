
/**
 * SubTreeBuilder.php
 *
 * Builds the statements for [sub_tree] fields.
 */

module source.langs.sql.PHPSQLParser.builders.subtree;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for [sub_tree] fields.
 * You can overwrite all functions to achieve another handling.
 */
class SubTreeBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildQuery($parsed) {
        auto myBuilder = new QueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSign($parsed) {
        auto myBuilder = new SignBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed, $delim = " ") {
        if ($parsed["sub_tree"] == '' || $parsed["sub_tree"] == false) {
            return "";
        }
        auto mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildInList(myValue);
            mySql  ~= this.buildSubQuery(myValue);
            mySql  ~= this.buildSelectBracketExpression(myValue);
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildQuery(myValue);
            mySql  ~= this.buildUserVariable(myValue);
            $sign = this.buildSign(myValue);
            mySql  ~= $sign;

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('expression subtree', $k, myValue, 'expr_type');
            }

            // We don't need whitespace between a sign and the following part.
            if ($sign == '') {
                mySql  ~= $delim;
            }
        }
        return substr(mySql, 0, -strlen($delim));
    }
}
