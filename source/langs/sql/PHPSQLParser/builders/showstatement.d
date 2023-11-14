
/**
 * ShowStatementBuilder.php
 *
 * Builds the SHOW statement. */

module source.langs.sql.PHPSQLParser.builders.showstatement;

/**
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class ShowStatementBuilder : ISqlBuilder {

    protected auto buildWHERE($parsed) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSHOW($parsed) {
        auto myBuilder = new ShowBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        $sql = this.buildSHOW($parsed);
        if (isset($parsed["WHERE"])) {
            $sql  ~= " "~ this.buildWHERE($parsed["WHERE"]);
        }
        return $sql;
    }
}
