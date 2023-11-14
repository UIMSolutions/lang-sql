/**
 * CreateBuilder.php
 *
 * Builds the CREATE statement
 */

module source.langs.sql.PHPSQLParser.builders.create.builder;

import lang.sql;

@safe:
/**
 * This class : the builder for the [CREATE] part. You can overwrite
 * all functions to achieve another handling.
 */
class CreateBuilder : ISqlBuilder {

    protected auto buildCreateTable($parsed) {
        auto myBuilder = new CreateTableBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildCreateIndex($parsed) {
        auto myBuilder = new CreateIndexBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSubTree($parsed) {
        auto myBuilder = new SubTreeBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array$parsed) {
        $create = $parsed["CREATE"];
        mySql = this.buildSubTree($create);

        if (($create["expr_type"] == ExpressionType :  : TABLE)
            || ($create["expr_type"] == ExpressionType :  : TEMPORARY_TABLE)) {
            mySql ~= ' '.this.buildCreateTable($parsed["TABLE"]);
        }
        if ($create["expr_type"] == ExpressionType :  : INDEX) {
            mySql ~= ' '.this.buildCreateIndex($parsed["INDEX"]);
        }

        // TODO: add more expr_types here (like VIEW), if available in parser output
        return "CREATE ".mySql;
    }

}
