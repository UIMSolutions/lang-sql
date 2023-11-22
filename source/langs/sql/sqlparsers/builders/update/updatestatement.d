module langs.sql.sqlparsers.builders.update.updatestatement;

/**
 * Builds the UPDATE statement 
 * This class : the builder for the whole Update statement. You can overwrite
 * all functions to achieve another handling. */
class UpdateStatementBuilder : ISqlBuilder {

    protected auto buildWHERE(parsedSQL) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSET(parsedSQL) {
        auto myBuilder = new SetBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildUPDATE(parsedSQL) {
        auto myBuilder = new UpdateBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = this.buildUPDATE(parsedSQL["UPDATE"]) . " " ~ this.buildSET(parsedSQL["SET"]);
        if ("WHERE" in parsedSQL["WHERE"]) {
            mySql ~= " " ~ this.buildWHERE(parsedSQL["WHERE"]);
        }
        return mySql;
    }
}
