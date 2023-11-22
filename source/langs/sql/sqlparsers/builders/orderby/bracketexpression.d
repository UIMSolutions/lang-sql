module langs.sql.sqlparsers.builders.orderby.bracketexpression;

/**
 * Builds bracket-expressions within the ORDER-BY part.
 * This class : the builder for bracket-expressions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByBracketExpressionBuilder : WhereBracketExpressionBuilder {

    protected auto buildDirection(parsedSQL) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = super.build(parsedSQL);
        if (!mySql.isEmpty) {
            mySql ~= this.buildDirection(parsedSQL);
        }
        return mySql;
    }

}
