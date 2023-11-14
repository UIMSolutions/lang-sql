
/**
 * CreateStatement.php
 *
 * Builds the CREATE statement */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the whole Create statement. You can overwrite
 * all functions to achieve another handling.
 */
class CreateStatementBuilder : ISqlBuilder {

    protected auto buildLIKE($parsed) {
        auto myBuilder = new LikeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectStatement($parsed) {
        auto myBuilder = new SelectStatementBuilder();
        return $builder.build($parsed);
    }

    protected auto buildCREATE($parsed) {
        auto myBuilder = new CreateBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = this.buildCREATE($parsed);
        if (isset($parsed["LIKE"])) {
            mySql  ~= " " . this.buildLIKE($parsed["LIKE"]);
        }
        if (isset($parsed["SELECT"])) {
            mySql  ~= " " . this.buildSelectStatement($parsed);
        }
        return mySql;
    }
}
