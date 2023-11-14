
/**
 * InsertStatement.php
 *
 * Builds the INSERT statement
 */

module source.langs.sql.PHPSQLParser.builders.insert.InsertStatementBuilder;

/**
 * This class : the builder for the whole Insert statement. You can overwrite
 * all functions to achieve another handling. */
class InsertStatementBuilder : ISqlBuilder {

    protected auto buildVALUES($parsed) {
        auto myBuilder = new ValuesBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildINSERT($parsed) {
        auto myBuilder = new InsertBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSELECT($parsed) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildSET($parsed) {
        auto myBuilder = new SetBuilder();
        return myBuilder.build($parsed);
    }
    
    auto build(array $parsed) {
        // TODO: are there more than one tables possible (like [INSERT][1])
        $sql = this.buildINSERT($parsed["INSERT"]);
        if (isset($parsed["VALUES"])) {
            $sql  ~= " " ~ this.buildVALUES($parsed["VALUES"]);
        }
        if (isset($parsed["SET"])) {
            $sql  ~= " " ~ this.buildSET($parsed["SET"]);
        }
        if (isset($parsed["SELECT"])) {
            $sql  ~= " " ~ this.buildSELECT($parsed);
        }
        return $sql;
    }
}