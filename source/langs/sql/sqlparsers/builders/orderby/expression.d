module lang.sql.parsers.builders;

/**
 * Builds expressions within the ORDER-BY part. */
 * This class : the builder for expressions within the ORDER-BY part. 
 * It must contain the direction. 
 * You can overwrite all functions to achieve another handling. */
class OrderByExpressionBuilder : WhereExpressionBuilder {

    protected auto buildDirection(parsedSql) {
        auto auto myBuilder = new DirectionBuilder();
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
