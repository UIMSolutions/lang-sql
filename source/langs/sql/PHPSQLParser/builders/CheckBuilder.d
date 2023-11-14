
/**
 * CheckBuilder.php
 *
 * Builds the CHECK statement part of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the CHECK statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class CheckBuilder : ISqlBuilder {

    protected auto buildSelectBracketExpression($parsed) {
        $builder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CHECK) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildSelectBracketExpression($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE check subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
