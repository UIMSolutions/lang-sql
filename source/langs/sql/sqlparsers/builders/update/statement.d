module langs.sql.sqlparsers.builders.update.updatestatement;
import lang.sql;

@safe:
// Builds the UPDATE statement 
class UpdateStatementBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        string mySql = this.buildUPDATE(parsedSql["UPDATE"]) ~ " " ~ this.buildSET(
            parsedSql["SET"]);
        if ("WHERE" in parsedSql["WHERE"]) {
           mySql ~= " " ~ this.buildWHERE(parsedSql["WHERE"]);
        }
        return mySql;
    }

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
}
