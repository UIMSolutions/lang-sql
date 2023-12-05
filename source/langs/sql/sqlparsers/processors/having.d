module langs.sql.sqlparsers.processors.having;

import lang.sql;

@safe:

// Parses the HAVING statements. 
class HavingProcessor : ExpressionListProcessor {

  auto process( mytokens, myselect = []) {
    Json parsed = super.process( mytokens);

    parsed.byKeyValue
      .each!(kv => processKeyValue(aKey, aValue));

    return myparsed;
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
          myparsed[myKey]["expr_type"] = expressionType("ALIAS");
          break;
        }
      }
    }
  }
