
/**
 * OrderByFunctionBuilder.php
 *
 * Builds functions within the ORDER-BY part.
 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for functions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class OrderByFunctionBuilder : FunctionBuilder {

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
