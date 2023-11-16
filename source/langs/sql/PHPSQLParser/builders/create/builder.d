module langs.sql.PHPSQLParser.builders.create.builder;

import lang.sql;

@safe:
/**
 * Builds the CREATE statement
 * This class : the builder for the [CREATE] part. You can overwrite
 * all functions to achieve another handling. */
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

    string build(array $parsed) {
        auto myCreate = $parsed["CREATE"];
        
        string mySql = this.buildSubTree(myCreate);

        if ((myCreate["expr_type"] == ExpressionType :  : TABLE)
            || (myCreate["expr_type"] == ExpressionType :  : TEMPORARY_TABLE)) {
            mySql ~= " " ~ this.buildCreateTable($parsed["TABLE"]);
        }
        if (myCreate["expr_type"] == ExpressionType :  : INDEX) {
            mySql ~= " " ~ this.buildCreateIndex($parsed["INDEX"]);
        }

        // TODO: add more expr_types here (like VIEW), if available in parser output
        return "CREATE " ~ mySql;
    }

}
