
/**
 * UpdateStatement.php
 *
 * Builds the UPDATE statement */

module langs.sql.PHPSQLParser.builders.updatestatement;

/**
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

    auto build(array $parsed) {
        $sql = this.buildUPDATE($parsed["UPDATE"]) . " "~ this.buildSET($parsed["SET"]);
        if (isset($parsed["WHERE"])) {
            $sql  ~= " "~ this.buildWHERE($parsed["WHERE"]);
        }
        return $sql;
    }
}
