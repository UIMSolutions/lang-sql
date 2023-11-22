module langs.sql.sqlparsers.builders.create.statement;

import lang.sql;

@safe:
/**
 * Builds the CREATE statement 
 * This class : the builder for the whole Create statement. You can overwrite
 * all functions to achieve another handling. */
class CreateStatementBuilder : ISqlBuilder {

    protected auto buildLike($parsed) {
        auto myBuilder = new LikeBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSelectStatement($parsed) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildCreate($parsed) {
        auto myBuilder = new CreateBuilder();
        return myBuilder.build($parsed);
    }

    string build(Json parsedSQL) {
        string mySql = this.buildCreate($parsed);
        
        mySql ~= $parsed.isSet("LIKE") ? " " ~ this.buildLike($parsed["LIKE"]) : "";
        mySql ~= $parsed.isSet("SELECT") ? " " ~ this.buildSelectStatement($parsed) : "";

        return mySql;
    }
}
