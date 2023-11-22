module lang.sql.parsers.builders;

/**
 * Builds the TRUNCATE statement 
 * This class : the builder for the whole Truncate statement. You can overwrite
 * all functions to achieve another handling. */
class TruncateStatementBuilder : ISqlBuilder {

    protected auto buildTRUNCATE(parsedSQL) {
        auto myBuilder = new TruncateBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildFROM(parsedSQL) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    string build(Json parsedSQL) {
        string mySql = this.buildTRUNCATE(parsedSQL);
        // mySql ~= " " ~ this.buildTRUNCATE(parsedSQL) // Uncomment when parser fills in expr_type=table
        
        return mySql;
    }

}
