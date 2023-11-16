module langs.sql.PHPSQLParser.processors.having;

import lang.sql;

@safe:

/**
 * Parses the HAVING statements. 
 * This class : the processor for the HAVING statement. 
 * You can overwrite all functions to achieve another handling. */
class HavingProcessor : ExpressionListProcessor {

  auto process($tokens, $select = []) {
    $parsed = super.process($tokens);

    foreach (myKey, myValue; $parsed) {
      if (myValue["expr_type"].isExpressionType(COLREF) {
        foreach ($select as$clause) {
          if (!isset($clause["alias"])) {
            continue;
          }

          if (!$clause["alias"]) {
            continue;
          }
          if ($clause["alias"]["no_quotes"] == myValue["no_quotes"]) {
            $parsed[$k]["expr_type"] = ExpressionType : : ALIAS;
            break;
          }
        }
      }
    }

    return $parsed;
  }
}



?  >
