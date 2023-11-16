module langs.sql.PHPSQLParser.builders.showstatement;

/**
 * Builds the SHOW statement. */
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class ShowStatementBuilder : ISqlBuilder {

    protected auto buildWHERE($parsed) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSHOW($parsed) {
        auto myBuilder = new ShowBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        string mySql = this.buildSHOW($parsed);
        if ($parsed.isSet("WHERE")) {
            mySql ~= " " ~ this.buildWHERE($parsed["WHERE"]);
        }
        return mySql;
    }
}
