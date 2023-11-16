module langs.sql.PHPSQLParser.builders.create.statement;

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

    string build(array $parsed) {
        string mySql = this.buildCreate($parsed);
        if (isset($parsed["LIKE"])) {
            mySql  ~= " "~ this.buildLike($parsed["LIKE"]);
        }
        if (isset($parsed["SELECT"])) {
            mySql  ~= " "~ this.buildSelectStatement($parsed);
        }
        return mySql;
    }
}
