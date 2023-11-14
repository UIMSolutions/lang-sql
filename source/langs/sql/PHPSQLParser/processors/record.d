
/**
 * RecordProcessor.php
 *
 * This file : a processor, which processes records of data
 * for an INSERT statement.
 */

module langs.sql.PHPSQLParser.processors.record;

/**
 * This class processes records of an INSERT statement.
 */
class RecordProcessor : AbstractProcessor {

    protected auto processExpressionList($unparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    auto process($unparsed) {
        $unparsed = this.removeParenthesisFromStart($unparsed);
        myValues = this.splitSQLIntoTokens($unparsed);

        foreach ($k :  myValue; myValues) {
            if (this.isCommaToken(myValue)) {
                myValues[$k] = "";
            }
        }
        return this.processExpressionList(myValues);
    }
}
