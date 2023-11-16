
/**
 * WhereExpressionBuilder.php
 *
 * Builds expressions within the WHERE part.
 */

module langs.sql.PHPSQLParser.builders.whereexpression;

import lang.sql;

@safe:

/**
 * This class : the builder for expressions within the WHERE part.
 * You can overwrite all functions to achieve another handling.
 */
class WhereExpressionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
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

    protected auto buildInList($parsed) {
        auto myBuilder = new InListBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildWhereExpression($parsed) {
        return this.build($parsed);
    }

    protected auto buildWhereBracketExpression($parsed) {
        auto myBuilder = new WhereBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildUserVariable($parsed) {
        auto myBuilder = new UserVariableBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSubQuery($parsed) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
      auto myBuilder = new ReservedBuilder();
      return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildInList(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildWhereExpression(myValue);
            mySql  ~= this.buildWhereBracketExpression(myValue);
            mySql  ~= this.buildUserVariable(myValue);
            mySql  ~= this.buildSubQuery(myValue);
            mySql  ~= this.buildReserved(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('WHERE expression subtree', myKey, myValue, "expr_type");
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return mySql;
    }

}
