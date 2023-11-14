
/**
 * OrderByExpressionBuilder.php
 *
 * Builds expressions within the ORDER-BY part.
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for expressions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling.
 */
class OrderByExpressionBuilder : WhereExpressionBuilder {

    protected auto buildDirection($parsed) {
        auto auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        auto mySql = super.build($parsed);
        if (mySql != '') {
            mySql  ~= this.buildDirection($parsed);
        }
        return mySql;
    }

}
