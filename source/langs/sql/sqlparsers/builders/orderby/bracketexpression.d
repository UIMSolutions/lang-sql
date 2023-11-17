module langs.sql.PHPSQLParser.builders.orderby.bracketexpression;

/**
 * Builds bracket-expressions within the ORDER-BY part.
 * This class : the builder for bracket-expressions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByBracketExpressionBuilder : WhereBracketExpressionBuilder {

    protected auto buildDirection($parsed) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        string mySql = super.build($parsed);
        if (!mySql.isEmpty) {
            mySql ~= this.buildDirection($parsed);
        }
        return mySql;
    }

}