module lang.sql.parsers.builders;

/**
 * Builds the TRUNCATE statement 
 * This class : the builder for the whole Truncate statement. You can overwrite
 * all functions to achieve another handling. */
class TruncateStatementBuilder : ISqlBuilder {

    protected auto buildTRUNCATE(parsedSql) {
        auto myBuilder = new TruncateBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildFROM(parsedSql) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        string mySql = this.buildTRUNCATE(parsedSql);
        // mySql ~= " " ~ this.buildTRUNCATE(parsedSql) // Uncomment when parser fills in expr_type=table
        
        return mySql;
    }

}
