
/**
 * OrderByColumnReferenceBuilder.php
 *
 * Builds column references within the ORDER-BY part.

 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for column references within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling.
 */
class OrderByColumnReferenceBuilder : ColumnReferenceBuilder {

    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
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
