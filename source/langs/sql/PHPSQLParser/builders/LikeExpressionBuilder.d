
/**
 * LikeExpressionBuilder.php
 *
 * Builds the LIKE keyword within parenthesis.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the (LIKE) keyword within a 
 * CREATE TABLE statement. There are difference to LIKE (without parenthesis), 
 * the latter is a top-level element of the output array.
 * You can overwrite all functions to achieve another handling.
 * 
 */
class LikeExpressionBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $index) {
        auto myBuilder = new TableBuilder();
        return $builder.build($parsed, $index);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::LIKE) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildTable($v, 0);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE create-def (like) subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
