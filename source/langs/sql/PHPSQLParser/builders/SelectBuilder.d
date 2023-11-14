
/**
 * SelectBuilder.php
 *
 * Builds the SELECT statement from the [SELECT] field.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the [SELECT] field. You can overwrite
 * all functions to achieve another handling.
 */
class SelectBuilder : ISqlBuilder {

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectExpression($parsed) {
        auto myBuilder = new SelectExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectBracketExpression($parsed) {
        auto myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }
    /**
     * Returns a well-formatted delimiter string. If you don't need nice SQL,
     * you could simply return $parsed["delim"].
     * 
     * @param array $parsed The part of the output array, which contains the current expression.
     * @return a string, which is added right after the expression
     */
    protected auto getDelimiter($parsed) {
        return (!isset($parsed["delim"]) || $parsed["delim"] == false ? '' : (trim($parsed["delim"]) . ' '));
    }

    auto build(array $parsed) {
        auto mySql = "";
        foreach (myKey, myValue; $parsed) {
            $len = mySql.length;
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildSelectBracketExpression($v);
            mySql  ~= this.buildSelectExpression($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildReserved($v);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('SELECT', $k, $v, 'expr_type');
            }

            mySql  ~= this.getDelimiter($v);
        }
        return "SELECT " . mySql;
    }
}
