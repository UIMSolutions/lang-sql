
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
 
 
 *  
 */
class ReplaceStatementBuilder : ISqlBuilder {

    protected auto buildVALUES($parsed) {
        $builder = new ValuesBuilder();
        return $builder.build($parsed);
    }

    protected auto buildREPLACE($parsed) {
        $builder = new ReplaceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSELECT($parsed) {
        $builder = new SelectStatementBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildSET($parsed) {
        $builder = new SetBuilder();
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
