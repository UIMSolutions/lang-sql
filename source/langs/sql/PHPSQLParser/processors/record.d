
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
        $values = this.splitSQLIntoTokens($unparsed);

        foreach ($values as $k => $v) {
            if (this.isCommaToken($v)) {
                $values[$k] = "";
            }
        }
        return this.processExpressionList($values);
    }
}
