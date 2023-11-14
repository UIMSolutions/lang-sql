
/**
 * ExplainProcessor.php
 *
 * This file : the processor for the DESCRIBE statements.
 */

module source.langs.sql.PHPSQLParser.processors.describe;

import lang.sql;

@safe:
//This class processes the DESCRIBE statements.
class DescribeProcessor : ExplainProcessor {

    protected auto isStatement($keys, $needle = "DESCRIBE") {
        return super.isStatement($keys, $needle);
    }
}

?>
