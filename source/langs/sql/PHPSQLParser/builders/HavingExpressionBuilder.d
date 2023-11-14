
/**
 * HavingExpressionBuilder.php
 *
 * Builds expressions within the HAVING part.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for expressions within the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *
 * @author  Ian Barker <ian@theorganicagency.com>
 
 
 *  
 */
class HavingExpressionBuilder : WhereExpressionBuilder {

    protected auto buildHavingExpression($parsed) {
        return this.build($parsed);
    }

    protected auto buildHavingBracketExpression($parsed) {
        $builder = new HavingBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildInList($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildHavingExpression($v);
            $sql  ~= this.buildHavingBracketExpression($v);
            $sql  ~= this.buildUserVariable($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('HAVING expression subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }

        $sql = substr($sql, 0, -1);
        return $sql;
    }

}
