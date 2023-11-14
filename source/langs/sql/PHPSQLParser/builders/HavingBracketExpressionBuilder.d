
/**
 * HavingBracketExpressionBuilder.php
 *
 * Builds bracket expressions within the HAVING part.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for bracket expressions within the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *
 * @author  Ian Barker <ian@theorganicagency.com>
 
 
 *  
 */
class HavingBracketExpressionBuilder : WhereBracketExpressionBuilder {
    
    protected auto buildHavingExpression($parsed) {
        $builder = new HavingExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::BRACKET_EXPRESSION) {
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
            $sql  ~= this.build($v);
            $sql  ~= this.buildUserVariable($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('HAVING expression subtree', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }

        $sql = "(" . substr($sql, 0, -1) . ")";
        return $sql;
    }

}
