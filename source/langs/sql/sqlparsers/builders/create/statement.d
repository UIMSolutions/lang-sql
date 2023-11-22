module langs.sql.sqlparsers.builders.create.statement;

import lang.sql;

@safe:
/**
 * Builds the CREATE statement 
 * This class : the builder for the whole Create statement. You can overwrite
 * all functions to achieve another handling. */
class CreateStatementBuilder : ISqlBuilder {

    protected auto buildLike(parsedSql) {
        auto myBuilder = new LikeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSelectStatement(parsedSql) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildCreate(parsedSql) {
        auto myBuilder = new CreateBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = this.buildCreate(parsedSql);
        
        mySql ~= parsedSql.isSet("LIKE") ? " " ~ this.buildLike(parsedSql["LIKE"]) : "";
        mySql ~= parsedSql.isSet("SELECT") ? " " ~ this.buildSelectStatement(parsedSql) : "";

        return mySql;
    }
}
