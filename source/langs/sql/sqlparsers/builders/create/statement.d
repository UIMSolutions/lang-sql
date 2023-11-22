module langs.sql.sqlparsers.builders.create.statement;

import lang.sql;

@safe:
/**
 * Builds the CREATE statement 
 * This class : the builder for the whole Create statement. You can overwrite
 * all functions to achieve another handling. */
class CreateStatementBuilder : ISqlBuilder {

    protected auto buildLike(parsedSQL) {
        auto myBuilder = new LikeBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSelectStatement(parsedSQL) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildCreate(parsedSQL) {
        auto myBuilder = new CreateBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = this.buildCreate(parsedSQL);
        
        mySql ~= parsedSQL.isSet("LIKE") ? " " ~ this.buildLike(parsedSQL["LIKE"]) : "";
        mySql ~= parsedSQL.isSet("SELECT") ? " " ~ this.buildSelectStatement(parsedSQL) : "";

        return mySql;
    }
}
