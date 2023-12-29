module langs.sql.parsers.processors.into;

/**
 * This file : the processor for the INTO statements.
 * This class processes the INTO statements.
 */
class IntoProcessor : Processor {

  /**
    * TODO: This is a dummy function, we cannot parse INTO as part of SELECT
    * at the moment
    */
  Json process(mytokenList) {
    myunparsed = mytokenList["INTO"];
    foreach (myKey, myToken; myunparsed) {
      if (this.isWhitespaceToken(myToken) || this.isCommaToken(myToken)) {
        unset(myunparsed[myKey]);
      }
    }
    mytokenList["INTO"] = array_values(myunparsed);
    return mytokenList;
  }
}
