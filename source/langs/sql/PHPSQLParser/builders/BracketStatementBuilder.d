
/**
 * BracketStatementBuilder.php
 *
 * Builds the parentheses around a statement.

 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
class BracketStatementBuilder : ISqlBuilder {

    protected auto buildSelectBracketExpression($parsed) {
        $builder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed, " ");
    }

    protected auto buildSelectStatement($parsed) {
        $builder = new SelectStatementBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed["BRACKET"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildSelectBracketExpression($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('BRACKET', $k, $v, 'expr_type');
            }
        }
        return trim($sql . " " . trim(this.buildSelectStatement($parsed)));
    }
}
