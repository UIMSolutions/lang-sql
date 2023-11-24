module langs.sql.sqlparsers.builders.orderby.bracketexpression;

// Builds bracket-expressions within the ORDER-BY part.
class OrderByBracketExpressionBuilder : WhereBracketExpressionBuilder {

    string build(Json parsedSql) {
        string mySql = super.build(parsedSql);
        if (!mySql.isEmpty) {
            mySql ~= this.buildDirection(parsedSql);
        }
        return mySql;
    }

    protected string buildDirection(Json parsedSql) {
        auto myBuilder = new DirectionBuilder();
        return myBuilder.build(parsedSql);
    }

}
