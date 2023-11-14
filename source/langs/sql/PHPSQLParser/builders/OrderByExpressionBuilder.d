
/**
 * OrderByExpressionBuilder.php
 *
 * Builds expressions within the ORDER-BY part.

 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for expressions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class OrderByExpressionBuilder : WhereExpressionBuilder {

    protected auto buildDirection($parsed) {
        $builder = new DirectionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = parent::build($parsed);
        if ($sql != '') {
            $sql  ~= this.buildDirection($parsed);
        }
        return $sql;
    }

}
