module lang.sql.parsers.builders;

/**
 * Builds the TRUNCATE statement 
 * This class : the builder for the whole Truncate statement. You can overwrite
 * all functions to achieve another handling. */
class TruncateStatementBuilder : ISqlBuilder {

    protected auto buildTRUNCATE($parsed) {
        auto myBuilder = new TruncateBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildFROM($parsed) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build($parsed);
    }
    
    string build(array $parsed) {
        string mySql = this.buildTRUNCATE($parsed);
        // mySql ~= " " ~ this.buildTRUNCATE($parsed) // Uncomment when parser fills in expr_type=table
        
        return mySql;
    }

}
