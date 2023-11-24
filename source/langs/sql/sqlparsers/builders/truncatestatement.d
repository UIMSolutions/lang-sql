module lang.sql.parsers.builders;

// Builds the TRUNCATE statement 
class TruncateStatementBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        string mySql = this.buildTRUNCATE(parsedSql);
        // mySql ~= " " ~ this.buildTRUNCATE(parsedSql) // Uncomment when parser fills in expr_type=table

        return mySql;
    }

    protected string buildTRUNCATE(Json parsedSql) {
        auto myBuilder = new TruncateBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildFROM(Json parsedSql) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSql);
    }
}
