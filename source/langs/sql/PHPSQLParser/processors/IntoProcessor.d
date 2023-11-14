
/**
 * IntoProcessor.php
 *
 * This file : the processor for the INTO statements.
 */

module lang.sql.parsers.processors;

/**
 * 
 * This class processes the INTO statements.
 * 
 * @author arothe */
class IntoProcessor : AbstractProcessor {

    /**
     * TODO: This is a dummy function, we cannot parse INTO as part of SELECT
     * at the moment
     */
    auto process($tokenList) {
        $unparsed = $tokenList["INTO"];
        foreach ($unparsed as $k => $token) {
            if (this.isWhitespaceToken($token) || this.isCommaToken($token)) {
                unset($unparsed[$k]);
            }
        }
        $tokenList["INTO"] = array_values($unparsed);
        return $tokenList;
    }
}
