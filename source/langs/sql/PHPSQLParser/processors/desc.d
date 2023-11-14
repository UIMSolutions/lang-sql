
/**
 * DescProcessor.php
 *
 * This file : the processor for the DESC statements, which is a short form of DESCRIBE.
. */

module langs.sql.PHPSQLParser.processors.desc;

import lang.sql;

@safe:
/**
 * 
 * This class processes the DESC statement.
 */
class DescProcessor : ExplainProcessor {

    protected auto isStatement($keys, $needle = "DESC") {
        return super.isStatement($keys, $needle);
    }
}
