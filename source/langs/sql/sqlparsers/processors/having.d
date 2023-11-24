module langs.sql.sqlparsers.processors.having;

import lang.sql;

@safe:

/**
 * Parses the HAVING statements. 
 * This class : the processor for the HAVING statement. 
 * . */
class HavingProcessor : ExpressionListProcessor {

  auto process($tokens, $select = []) {
    $parsed = super.process($tokens);

    foreach (myKey, myValue; $parsed) {
      if (myValue["expr_type"].isExpressionType("COLREF")) {
        foreach (myClause; $select) {
          auto aliasClause = myClause.get("alias", null);
          if (aliasClause.isNull) {
            continue;
          }

          if (!aliasClause) {
            continue;
          }
          if (myClause["alias"]["no_quotes"] == myValue["no_quotes"]) {
            $parsed[myKey]["expr_type"] = expressionType("ALIAS");
            break;
          }
        }
      }
    }

    return $parsed;
  }
}
