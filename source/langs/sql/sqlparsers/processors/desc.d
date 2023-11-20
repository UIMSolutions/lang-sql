module langs.sql.sqlparsers.processors.desc;

import lang.sql;

@safe:
/**
 * Processor for the DESC statements, which is a short form of DESCRIBE.
 * This class processes the DESC statement.
 */
class DescProcessor : ExplainProcessor {
    protected auto isStatement(myKeys, string aNeedle = "DESC") {
        return super.isStatement(myKeys, aNeedle);
    }
}
