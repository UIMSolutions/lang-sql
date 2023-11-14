
/**
 * ReplaceStatement.php
 *
 * Builds the REPLACE statement
 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the whole Replace statement. You can overwrite
 * all functions to achieve another handling.
 * 
 */
class ReplaceStatementBuilder : ISqlBuilder {

    protected auto buildVALUES($parsed) {
        myBuilder = new ValuesBuilder();
        return $builder.build($parsed);
    }

    protected auto buildREPLACE($parsed) {
        myBuilder = new ReplaceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSELECT($parsed) {
        myBuilder = new SelectStatementBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildSET($parsed) {
        myBuilder = new SetBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        // TODO: are there more than one tables possible (like [REPLACE][1])
        $sql = this.buildREPLACE($parsed["REPLACE"]);
        if (isset($parsed["VALUES"])) {
            $sql  ~= ' ' . this.buildVALUES($parsed["VALUES"]);
        }
        if (isset($parsed["SET"])) {
            $sql  ~= ' ' . this.buildSET($parsed["SET"]);
        }
        if (isset($parsed["SELECT"])) {
            $sql  ~= ' ' . this.buildSELECT($parsed);
        }
        return $sql;
    }
}
