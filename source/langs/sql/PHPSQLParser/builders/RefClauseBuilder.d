
/**
 * RefClauseBuilder.php
 *
 * Builds reference clauses within a JOIN.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the references clause within a JOIN.
 * You can overwrite all functions to achieve another handling.
 */
class RefClauseBuilder : ISqlBuilder {

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed == false) {
            return "";
        }
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildBracketExpression($v);
            mySql  ~= this.buildInList($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildSubQuery($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('expression ref_clause', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
