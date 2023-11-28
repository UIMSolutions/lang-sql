module langs.sql.sqlparsers.processors.bracket;

import lang.sql;

@safe:

// This class processes the parentheses around the statement.
class BracketProcessor : AbstractProcessor {

    protected auto processTopLevel( mysql) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor.process( mysql);
    }

    auto process( mytokens) {
        string myToken = this.removeParenthesisFromStart( mytokens[0]);
        Json subtree = this.processTopLevel(myToken);

         myremainingExpressions = this.getRemainingNotBracketExpression(subtree);

        if (subtree.isSet("BRACKET")) {
            subtree = subtree["BRACKET"];
        }

        if (subtree.isSet("SELECT")) {
            subtree = [
                    createExpression("QUERY", myToken), "sub_tree" : subtree];
        }

        Json result = createExpression("BRACKET_EXPRESSION",  mytokens[0].trim);
        result["sub_tree"] = subtree;
        result["remaining_expressions"] =  myremainingExpressions;

        return [result];
    }

    private auto getRemainingNotBracketExpression(subtree) {
        // https://github.com/greenlion/PHP-SQL-Parser/issues/279
        // https://github.com/sinri/PHP-SQL-Parser/commit/eac592a0e19f1df6f420af3777a6d5504837faa7
        // as there is no pull request for 279 by the user. His solution works and tested.
        if (subtree.isEmpty) subtree = [];// as a fix by Sinri 20180528
         myremainingExpressions = [];
        string[] ignoredKeys = ["BRACKET", "SELECT", "FROM"];
         mysubtreeKeys = array_keys(subtree);

        foreach(myKey;  mysubtreeKeys) {
            if(!in_array(myKey, ignoredKeys)) {
                 myremainingExpressions[myKey] = subtree[myKey];
            }
        }

        return  myremainingExpressions;
    }

}

