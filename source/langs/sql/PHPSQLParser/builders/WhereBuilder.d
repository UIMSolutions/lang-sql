
/**
 * WhereBuilder.php
 *
 * Builds the WHERE part.
 *
 *

 * */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the WHERE part.
 * You can overwrite all functions to achieve another handling.
 */
class WhereBuilder : ISqlBuilder {

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

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
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

    protected auto buildWhereBracketExpression($parsed) {
        auto myBuilder = new WhereBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
      auto myBuilder = new ReservedBuilder();
      return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = "WHERE ";
        foreach (myKey, myValue; $parsed) {
            $len = strlen(mySql);

            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildSubQuery(myValue);
            mySql  ~= this.buildInList(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildWhereExpression(myValue);
            mySql  ~= this.buildWhereBracketExpression(myValue);
            mySql  ~= this.buildUserVariable(myValue);
            mySql  ~= this.buildReserved(myValue);
            
            if (strlen(mySql) == $len) {
                throw new UnableToCreateSQLException('WHERE', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }

}
