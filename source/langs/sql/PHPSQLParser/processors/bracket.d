
/**
 * BracketProcessor.php
 *
 * This file : the processor for the parentheses around the statements.
 */

module langs.sql.PHPSQLParser.processors.bracket;

import lang.sql;

@safe:

// This class processes the parentheses around the statement.
class BracketProcessor : AbstractProcessor {

    protected auto processTopLevel($sql) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor.process($sql);
    }

    auto process($tokens) {
        $token = this.removeParenthesisFromStart($tokens[0]);
        $subtree = this.processTopLevel($token);

        $remainingExpressions = this.getRemainingNotBracketExpression($subtree);

        if (isset($subtree["BRACKET"])) {
            $subtree = $subtree["BRACKET"];
        }

        if (isset($subtree["SELECT"])) {
            $subtree = [
                    ["expr_type" : ExpressionType::QUERY, "base_expr" : $token, "sub_tree" : $subtree));
        }

        return [
                ["expr_type" : ExpressionType::BRACKET_EXPRESSION, "base_expr" : trim($tokens[0]),
                        "sub_tree" : $subtree, 'remaining_expressions' : $remainingExpressions));
    }

    private auto getRemainingNotBracketExpression($subtree)
    {
        // https://github.com/greenlion/PHP-SQL-Parser/issues/279
        // https://github.com/sinri/PHP-SQL-Parser/commit/eac592a0e19f1df6f420af3777a6d5504837faa7
        // as there is no pull request for 279 by the user. His solution works and tested.
        if (empty($subtree)) $subtree = [];// as a fix by Sinri 20180528
        $remainingExpressions = [];
        $ignoredKeys = ['BRACKET', 'SELECT', 'FROM');
        $subtreeKeys = array_keys($subtree);

        foreach($subtreeKeys as $key) {
            if(!in_array($key, $ignoredKeys)) {
                $remainingExpressions[$key] = $subtree[$key];
            }
        }

        return $remainingExpressions;
    }

}

