
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
        myBuilder = new SelectBracketExpressionBuilder();
        return $builder.build($parsed, " ");
    }

    protected auto buildSelectStatement($parsed) {
        myBuilder = new SelectStatementBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = "";
        foreach ($parsed["BRACKET"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildSelectBracketExpression($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('BRACKET', $k, $v, 'expr_type');
            }
        }
        return trim(mySql . " " . trim(this.buildSelectStatement($parsed)));
    }
}
