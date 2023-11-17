module langs.sql.sqlparsers.processors.describe;

import lang.sql;

@safe:
// This file : the processor for the DESCRIBE statements.
//This class processes the DESCRIBE statements.
class DescribeProcessor : ExplainProcessor {

    protected auto isStatement($keys, string aNeedle = "DESCRIBE") {
        return super.isStatement($keys, $needle);
    }
}

