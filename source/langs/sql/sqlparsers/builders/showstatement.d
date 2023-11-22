module langs.sql.sqlparsers.builders.showstatement;

/**
 * Builds the SHOW statement. */
 * This class : the builder for the SHOW statement. 
 *  */
class ShowStatementBuilder : ISqlBuilder {

    protected auto buildWHERE(parsedSql) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSHOW(parsedSql) {
        auto myBuilder = new ShowBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = this.buildSHOW(parsedSql);
        if (parsedSql.isSet("WHERE")) {
            mySql ~= " " ~ this.buildWHERE(parsedSql["WHERE"]);
        }
        return mySql;
    }
}
