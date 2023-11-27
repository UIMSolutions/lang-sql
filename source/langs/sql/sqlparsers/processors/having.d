module langs.sql.sqlparsers.processors.having;

import lang.sql;

@safe:

// Parses the HAVING statements. 
class HavingProcessor : ExpressionListProcessor {

  auto process($tokens, $select = []) {
    Json parsed = super.process($tokens);

    parsed.byKeyValue
      .each!(kv => processKeyValue(aKey, aValue));

    return $parsed;
  }

  protected void processKeyValue(string aKey, Json aValue) {
    if (myValue.isExpressionType("COLREF")) {
      foreach (myClause; aValue) {
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
