module langs.sql.sqlparsers.builders.replacestatement;

/**
 * Builds the REPLACE statement 
 * This class : the builder for the whole Replace statement. You can overwrite
 * all functions to achieve another handling. */
class ReplaceStatementBuilder : ISqlBuilder {

    protected auto buildVALUES(parsedSQL) {
        auto myBuilder = new ValuesBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildREPLACE(parsedSQL) {
        auto myBuilder = new ReplaceBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSELECT(parsedSQL) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildSET(parsedSQL) {
        auto myBuilder = new SetBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    string build(Json parsedSQL) {
        // TODO: are there more than one tables possible (like [REPLACE][1])
        string mySql = this.buildREPLACE(parsedSQL["REPLACE"]);
        mySql ~= parsedSQL.isSet("VALUES") ? " " ~ this.buildVALUES(parsedSQL["VALUES"]) : "";
        mySql ~= parsedSQL.isSet("SET") ? " " ~ this.buildSET(parsedSQL["SET"]) : "";
        mySql ~= parsedSQL.isSet("SELECT") ? " " ~ this.buildSELECT(parsedSQL) : "";
        
        return mySql;
    }
}
