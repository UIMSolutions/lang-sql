
/**
 * DeleteStatementBuilder.php
 *
 * Builds the DELETE statement
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the whole Delete statement. You can overwrite
 * all functions to achieve another handling.
 */
class DeleteStatementBuilder : ISqlBuilder {
    protected auto buildWHERE($parsed) {
        auto myBuilder = new WhereBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFROM($parsed) {
        auto myBuilder = new FromBuilder();
        return $builder.build($parsed);
    }

    protected auto buildDELETE($parsed) {
        auto myBuilder = new DeleteBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = this.buildDELETE($parsed["DELETE"]) . " " . this.buildFROM($parsed["FROM"]);
        if (isset($parsed["WHERE"])) {
            mySql  ~= " " . this.buildWHERE($parsed["WHERE"]);
        }
        return mySql;
    }

}
