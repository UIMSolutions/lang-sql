module langs.sql.sqlparsers.builders.create.statement;

import lang.sql;

@safe:
// Builds the CREATE statement 
class CreateStatementBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        string mySql = this.buildCreate(parsedSql);

        mySql ~= parsedSql.isSet("LIKE") ? " " ~ this.buildLike(parsedSql["LIKE"]) : "";
        mySql ~= parsedSql.isSet("SELECT") ? " " ~ this.buildSelectStatement(parsedSql) : "";

        return mySql;
    }

    protected string buildLike(Json parsedSql) {
        auto myBuilder = new LikeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildSelectStatement(Json parsedSql) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildCreate(Json parsedSql) {
        auto myBuilder = new CreateBuilder();
        return myBuilder.build(parsedSql);
    }
}
