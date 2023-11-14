
/**
 * ShowStatementBuilder.php
 *
 * Builds the SHOW statement.
 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class ShowStatementBuilder : ISqlBuilder {

    protected auto buildWHERE($parsed) {
        $builder = new WhereBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSHOW($parsed) {
        $builder = new ShowBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = this.buildSHOW($parsed);
        if (isset($parsed["WHERE"])) {
            $sql  ~= " " . this.buildWHERE($parsed["WHERE"]);
        }
        return $sql;
    }
}
