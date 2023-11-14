
/**
 * OrderByBracketExpressionBuilder.php
 *
 * Builds bracket-expressions within the ORDER-BY part.
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for bracket-expressions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByBracketExpressionBuilder : WhereBracketExpressionBuilder {

    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = super.build($parsed);
        if ($sql != '') {
            $sql  ~= this.buildDirection($parsed);
        }
        return $sql;
    }

}
