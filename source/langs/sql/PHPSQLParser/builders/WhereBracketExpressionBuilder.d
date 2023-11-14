
/**
 * WhereBracketExpressionBuilder.php
 *
 * Builds bracket expressions within the WHERE part.
 *
 *

 *
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for bracket expressions within the WHERE part.
 * You can overwrite all functions to achieve another handling.

 */
class WhereBracketExpressionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
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

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWhereExpression($parsed) {
        auto myBuilder = new WhereExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
      auto myBuilder = new ReservedBuilder();
      return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::BRACKET_EXPRESSION) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildInList($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildWhereExpression($v);
            mySql  ~= this.build($v);
            mySql  ~= this.buildUserVariable($v);
           // mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildSubQuery($v);
            
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('WHERE expression subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = "(" . substr(mySql, 0, -1) . ")";
        return mySql;
    }

}
