module langs.sql.sqlparsers.processors.options;

import lang.sql;

@safe:

// This file : the processor for the statement options.
// This class processes the statement options.
class OptionsProcessor : Processor {

  auto process(mytokens) {
    Json results = Json.emptyArray;

    foreach (myToken; mytokens) {

      auto myTokenList = this.splitSQLIntoTokens(myToken);
      auto myresult =  mytokenList
        .map!(token => token.strip)
        .filter!(token => !token.isEmpty)
        .map!(token => createExpression("RESERVED", token))
        .array;

      Json newExpression = createExpression("EXPRESSION", myToken.strip);
      newExpression["sub_tree"] = myresult;

      results ~= newExpression;
    }

    return results;
  }
}
