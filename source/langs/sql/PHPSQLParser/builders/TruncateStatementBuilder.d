
/**
 * TruncateStatementBuilder.php
 *
 * Builds the TRUNCATE statement
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the whole Truncate statement. You can overwrite
 * all functions to achieve another handling.
 */
class TruncateStatementBuilder : ISqlBuilder {

    protected auto buildTRUNCATE($parsed) {
        auto myBuilder = new TruncateBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFROM($parsed) {
        auto myBuilder = new FromBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        $sql = this.buildTRUNCATE($parsed);
        // $sql  ~= " " . this.buildTRUNCATE($parsed) // Uncomment when parser fills in expr_type=table
        
        return $sql;
    }

}
