
/**
 * OrderByBracketExpressionBuilder.php
 *
 * Builds bracket-expressions within the ORDER-BY part.
 */

module source.langs.sql.PHPSQLParser.builders.orderby.bracketexpression;

/**
 * This class : the builder for bracket-expressions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByBracketExpressionBuilder : WhereBracketExpressionBuilder {

    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        auto $sql = super.build($parsed);
        if ($sql != "") {
            $sql  ~= this.buildDirection($parsed);
        }
        return $sql;
    }

}
