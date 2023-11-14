
/**
 * DefaultProcessor.php
 *
 * This file : the processor the unparsed sql string given by the user.
 *
 *

 *
 */

module lang.sql.parsers.processors;

/**
 * This class processes the incoming sql string.

 */
class DefaultProcessor : AbstractProcessor {

    protected auto isUnion($tokens) {
        return UnionProcessor::isUnion($tokens);
    }

    protected auto processUnion($tokens) {
        // this is the highest level lexical analysis. This is the part of the
        // code which finds UNION and UNION ALL query parts
        $processor = new UnionProcessor(this.options);
        return $processor.process($tokens);
    }

    protected auto processSQL($tokens) {
        $processor = new SQLProcessor(this.options);
        return $processor.process($tokens);
    }

    auto process($sql) {

        $inputArray = this.splitSQLIntoTokens($sql);
        $queries = this.processUnion($inputArray);

        // If there was no UNION or UNION ALL in the query, then the query is
        // stored at $queries[0].
        if (!empty($queries) && !this.isUnion($queries)) {
            $queries = this.processSQL($queries[0]);
        }

        return $queries;
    }

    auto revokeQuotation($sql) {
        return super.revokeQuotation($sql);
    }
}

?>
