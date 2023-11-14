
/**
 * SelectBuilder.php
 *
 * Builds the SELECT statement from the [SELECT] field.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the [SELECT] field. You can overwrite
 * all functions to achieve another handling.
 *
 
 
 *  
 */
class SelectBuilder : ISqlBuilder {

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        $builder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectExpression($parsed) {
        $builder = new SelectExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectBracketExpression($parsed) {
        $builder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColRef($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
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
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildSelectBracketExpression($v);
            $sql  ~= this.buildSelectExpression($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildReserved($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('SELECT', $k, $v, 'expr_type');
            }

            $sql  ~= this.getDelimiter($v);
        }
        return "SELECT " . $sql;
    }
}
