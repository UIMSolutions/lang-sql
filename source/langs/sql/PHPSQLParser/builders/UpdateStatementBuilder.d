
/**
 * UpdateStatement.php
 *
 * Builds the UPDATE statement
 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the whole Update statement. You can overwrite
 * all functions to achieve another handling.
 * 
 */
class UpdateStatementBuilder : ISqlBuilder {

    protected auto buildWHERE($parsed) {
        myBuilder = new WhereBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSET($parsed) {
        myBuilder = new SetBuilder();
        return $builder.build($parsed);
    }

    protected auto buildUPDATE($parsed) {
        myBuilder = new UpdateBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = this.buildUPDATE($parsed["UPDATE"]) . " " . this.buildSET($parsed["SET"]);
        if (isset($parsed["WHERE"])) {
            $sql  ~= " " . this.buildWHERE($parsed["WHERE"]);
        }
        return $sql;
    }
}
