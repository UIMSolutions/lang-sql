
/**
 * ExplainProcessor.php
 *
 * This file : the processor for the DESCRIBE statements.
 *
 *

 *
 */

module lang.sql.parsers.processors;

/**
 * This class processes the DESCRIBE statements.

 */
class DescribeProcessor : ExplainProcessor {

    protected auto isStatement($keys, $needle = "DESCRIBE") {
        return super.isStatement($keys, $needle);
    }
}

?>
