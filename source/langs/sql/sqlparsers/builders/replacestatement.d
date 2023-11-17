module langs.sql.sqlparsers.builders.replacestatement;

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
        mySql ~= $parsed.isSet("VALUES") ? " " ~ this.buildVALUES($parsed["VALUES"]) : "";
        mySql ~= $parsed.isSet("SET") ? " " ~ this.buildSET($parsed["SET"]) : "";
        mySql ~= $parsed.isSet("SELECT") ? " " ~ this.buildSELECT($parsed) : "";
        
        return mySql;
    }
}
