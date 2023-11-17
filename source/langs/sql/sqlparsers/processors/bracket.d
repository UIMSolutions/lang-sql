module langs.sql.sqlparsers.processors.bracket;

import lang.sql;

@safe:

// This file : the processor for the parentheses around the statements.
// This class processes the parentheses around the statement.
class BracketProcessor : AbstractProcessor {

    protected auto processTopLevel($sql) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor.process($sql);
    }

    auto process($tokens) {
        $token = this.removeParenthesisFromStart($tokens[0]);
        $subtree = this.processTopLevel($token];

        $remainingExpressions = this.getRemainingNotBracketExpression($subtree);

        if ($subtree.isSet("BRACKET")) {
            $subtree = $subtree["BRACKET"];
        }

        if ($subtree.isSet("SELECT")) {
            $subtree = [
                    ["expr_type" : expressionType("QUERY"), "base_expr" : $token, "sub_tree" : $subtree]];
        }

        return [
                ["expr_type" : expressionType("BRACKET_EXPRESSION"), "base_expr" : trim($tokens[0]),
                        "sub_tree" : $subtree, 'remaining_expressions' : $remainingExpressions]];
    }

    private auto getRemainingNotBracketExpression($subtree)
    {
        // https://github.com/greenlion/PHP-SQL-Parser/issues/279
        // https://github.com/sinri/PHP-SQL-Parser/commit/eac592a0e19f1df6f420af3777a6d5504837faa7
        // as there is no pull request for 279 by the user. His solution works and tested.
        if ($subtree.isEmpty) $subtree = [];// as a fix by Sinri 20180528
        $remainingExpressions = [];
        $ignoredKeys = ['BRACKET', 'SELECT', 'FROM');
        $subtreeKeys = array_keys($subtree);

        foreach(myKey; $subtreeKeys) {
            if(!in_array(myKey, $ignoredKeys)) {
                $remainingExpressions[myKey] = $subtree[myKey];
            }
        }

        return $remainingExpressions;
    }

}

