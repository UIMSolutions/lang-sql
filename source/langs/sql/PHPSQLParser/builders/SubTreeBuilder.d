
/**
 * SubTreeBuilder.php
 *
 * Builds the statements for [sub_tree] fields.
 *
 *

 *
 */

module source.langs.sql.PHPSQLParser.builders.SubTreeBuilder;
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
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildInList($v);
            mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildSelectBracketExpression($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildQuery($v);
            mySql  ~= this.buildUserVariable($v);
            $sign = this.buildSign($v);
            mySql  ~= $sign;

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('expression subtree', $k, $v, 'expr_type');
            }

            // We don't need whitespace between a sign and the following part.
            if ($sign == '') {
                mySql  ~= $delim;
            }
        }
        return substr(mySql, 0, -strlen($delim));
    }
}
