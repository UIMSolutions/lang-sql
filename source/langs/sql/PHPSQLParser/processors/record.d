
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
        auto unparsedCorrected = this.removeParenthesisFromStart($unparsed);
        auto myTokens = this.splitSQLIntoTokens(unparsedCorrected);

        myTokens.byKeyValue
            .filter!(kv => this.isCommaToken(kv.value))
            .each!(kv => myTokens[kv.key] = "");
        
        return this.processExpressionList(myTokens);
    }
}
