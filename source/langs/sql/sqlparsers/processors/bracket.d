module langs.sql.sqlparsers.processors.bracket;

import lang.sql;

@safe:

// This class processes the parentheses around the statement.
class BracketProcessor : AbstractProcessor {

  protected auto processTopLevel(mysql) {
    auto myProcessor = new DefaultProcessor(this.options);
    return myProcessor.process(mysql);
  }

  auto process(string[] someTokens) {
    string myToken = this.removeParenthesisFromStart(someTokens[0]);
    Json myProcessTopLevel = this.processTopLevel(myToken);

    Json myRemainingExpressions = getRemainingNotBracketExpression(myProcessTopLevel);

    if (myProcessTopLevel.isSet("BRACKET")) {
     myProcessTopLevel = myProcessTopLevel["BRACKET"];
    }

    if (myProcessTopLevel.isSet("SELECT")) {
     myProcessTopLevel = createExpression("QUERY", myToken);
     myProcessTopLevel["sub_tree"] = myProcessTopLevel;
    }

    Json result = createExpression("BRACKET_EXPRESSION", someTokens[0].strip);
    result["sub_tree"] = myProcessTopLevel;
    result["remaining_expressions"] = myRemainingExpressions;

    return [result];
  }

  private auto getRemainingNotBracketExpression(subtree) {
    // https://github.com/greenlion/PHP-SQL-Parser/issues/279
    // https://github.com/sinri/PHP-SQL-Parser/commit/eac592a0e19f1df6f420af3777a6d5504837faa7
    // as there is no pull request for 279 by the user. His solution works and tested.
    if (subtree.isEmpty) {
      subtree = [];
    }

    Json myRemainingExpressions = Json.emptyObject;
    string[] ignoredKeys = ["BRACKET", "SELECT", "FROM"];

    subtree.keys
      .filter!(key => !ignoredKeys.has(key))
      .each!(key => myRemainingExpressions[key] = subtree[key]);

    return myRemainingExpressions;
  }

}
