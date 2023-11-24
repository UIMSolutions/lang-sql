module lang.sql.parsers.builders;

/**
 * Builds the TRUNCATE statement 
 * This class : the builder for the whole Truncate statement. You can overwrite
 * all functions to achieve another handling. */
class TruncateStatementBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        string mySql = this.buildTRUNCATE(parsedSql);
        // mySql ~= " " ~ this.buildTRUNCATE(parsedSql) // Uncomment when parser fills in expr_type=table

        return mySql;
    }

    protected auto buildTRUNCATE(Json parsedSql) {
        auto myBuilder = new TruncateBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildFROM(Json parsedSql) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSql);
    }
}
