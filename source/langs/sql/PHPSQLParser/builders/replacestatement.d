module source.langs.sql.PHPSQLParser.builders.replacestatement;

/**
 * Builds the REPLACE statement 
 * This class : the builder for the whole Replace statement. You can overwrite
 * all functions to achieve another handling. */
class ReplaceStatementBuilder : ISqlBuilder {

    protected auto buildVALUES($parsed) {
        auto myBuilder = new ValuesBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildREPLACE($parsed) {
        auto myBuilder = new ReplaceBuilder();
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
    
    string build(array $parsed) {
        // TODO: are there more than one tables possible (like [REPLACE][1])
        string mySql = this.buildREPLACE($parsed["REPLACE"]);
        if ("VALUES" in $parsed) {
            mySql  ~= " " ~ this.buildVALUES($parsed["VALUES"]);
        }
        if ("SET" in $parsed[]) {
            mySql  ~= " " ~ this.buildSET($parsed["SET"]);
        }
        if ("SELECT" in $parsed[]) {
            mySql  ~= " " ~ this.buildSELECT($parsed);
        }
        return mySql;
    }
}
