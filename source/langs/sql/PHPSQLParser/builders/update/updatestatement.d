module source.langs.sql.PHPSQLParser.builders.update.updatestatement;

/**
 * Builds the UPDATE statement 
 * This class : the builder for the whole Update statement. You can overwrite
 * all functions to achieve another handling. */
class UpdateStatementBuilder : ISqlBuilder {

    protected auto buildWHERE($parsed) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSET($parsed) {
        auto myBuilder = new SetBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildUPDATE($parsed) {
        auto myBuilder = new UpdateBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        auto mySql = this.buildUPDATE($parsed["UPDATE"]) . " "~ this.buildSET($parsed["SET"]);
        if ("WHERE" in $parsed["WHERE"]) {
            mySql  ~= " " ~ this.buildWHERE($parsed["WHERE"]);
        }
        return mySql;
    }
}
