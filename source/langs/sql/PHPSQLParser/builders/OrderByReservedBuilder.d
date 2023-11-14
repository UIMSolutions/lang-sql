
/**
 * OrderByReservedBuilder.php
 *
 * Builds reserved keywords within the ORDER-BY part.
 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for reserved keywords within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class OrderByReservedBuilder : ReservedBuilder {

    protected auto buildDirection($parsed) {
        $builder = new DirectionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = super.build($parsed);
        if ($sql != '') {
            $sql  ~= this.buildDirection($parsed);
        }
        return $sql;
    }

}
