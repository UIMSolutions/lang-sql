module langs.sql.sqlparsers.builders.showstatement;

/**
 * Builds the SHOW statement. */
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class ShowStatementBuilder : ISqlBuilder {

    protected auto buildWHERE(parsedSQL) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSHOW(parsedSQL) {
        auto myBuilder = new ShowBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = this.buildSHOW(parsedSQL);
        if (parsedSQL.isSet("WHERE")) {
            mySql ~= " " ~ this.buildWHERE(parsedSQL["WHERE"]);
        }
        return mySql;
    }
}
