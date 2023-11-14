/**
 * CreateBuilder.php
 *
 * Builds the CREATE statement
 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * This class : the builder for the [CREATE] part. You can overwrite
 * all functions to achieve another handling.
 *
 
 
 *  
 */
class CreateBuilder : ISqlBuilder {

    protected auto buildCreateTable($parsed) {
        $builder = new CreateTableBuilder();
        return $builder.build($parsed);
    }

    protected auto buildCreateIndex($parsed) {
        $builder = new CreateIndexBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSubTree($parsed) {
        $builder = new SubTreeBuilder();
        return $builder.build($parsed);
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
