module langs.sql.PHPSQLParser.processors.into;

/**
 * This file : the processor for the INTO statements.
 * This class processes the INTO statements.
 */
class IntoProcessor : AbstractProcessor {

  /**
    * TODO: This is a dummy function, we cannot parse INTO as part of SELECT
    * at the moment
    */
  auto process($tokenList) {
    $unparsed = $tokenList["INTO"];
    foreach (myKey, myToken; $unparsed) {
      if (this.isWhitespaceToken(myToken) || this.isCommaToken(myToken)) {
        unset($unparsed[myKey]);
      }
    }
    $tokenList["INTO"] = array_values($unparsed);
    return $tokenList;
  }
}
