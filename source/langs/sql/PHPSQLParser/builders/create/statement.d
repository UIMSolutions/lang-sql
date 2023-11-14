
/**
 * CreateStatement.php
 *
 * Builds the CREATE statement */

module langs.sql.PHPSQLParser.builders.create.statement;

import lang.sql;

@safe:
/**
 * This class : the builder for the whole Create statement. You can overwrite
 * all functions to achieve another handling. */
class CreateStatementBuilder : ISqlBuilder {

    protected auto buildLIKE($parsed) {
        auto myBuilder = new LikeBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSelectStatement($parsed) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildCREATE($parsed) {
        auto myBuilder = new CreateBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = this.buildCREATE($parsed);
        if (isset($parsed["LIKE"])) {
            mySql  ~= " "~ this.buildLIKE($parsed["LIKE"]);
        }
        if (isset($parsed["SELECT"])) {
            mySql  ~= " "~ this.buildSelectStatement($parsed);
        }
        return mySql;
    }
}
