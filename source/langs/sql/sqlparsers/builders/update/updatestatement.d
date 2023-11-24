module langs.sql.sqlparsers.builders.update.updatestatement;

/**
 * Builds the UPDATE statement 
 * This class : the builder for the whole Update statement. You can overwrite
 * all functions to achieve another handling. */
class UpdateStatementBuilder : ISqlBuilder {

    protected string buildWHERE(Json parsedSql) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSET(Json parsedSql) {
        auto myBuilder = new SetBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildUPDATE(Json parsedSql) {
        auto myBuilder = new UpdateBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = this.buildUPDATE(parsedSql["UPDATE"]) . " " ~ this.buildSET(parsedSql["SET"]);
        if ("WHERE" in parsedSql["WHERE"]) {
            mySql ~= " " ~ this.buildWHERE(parsedSql["WHERE"]);
        }
        return mySql;
    }
}
