module langs.sql.sqlparsers.builders.orderby.bracketexpression;

/**
 * Builds bracket-expressions within the ORDER-BY part.
 * This class : the builder for bracket-expressions within the ORDER-BY part. 
 * It must contain the direction. 
 *  */
class OrderByBracketExpressionBuilder : WhereBracketExpressionBuilder {

    protected auto buildDirection(parsedSql) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = super.build(parsedSql);
        if (!mySql.isEmpty) {
            mySql ~= this.buildDirection(parsedSql);
        }
        return mySql;
    }

}
