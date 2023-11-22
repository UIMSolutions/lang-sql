module langs.sql.sqlparsers.builders.replacestatement;

/**
 * Builds the REPLACE statement 
 * This class : the builder for the whole Replace statement. You can overwrite
 * all functions to achieve another handling. */
class ReplaceStatementBuilder : ISqlBuilder {

    protected auto buildVALUES(Json parsedSql) {
        auto myBuilder = new ValuesBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildREPLACE(Json parsedSql) {
        auto myBuilder = new ReplaceBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSELECT(Json parsedSql) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildSET(Json parsedSql) {
        auto myBuilder = new SetBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        // TODO: are there more than one tables possible (like [REPLACE][1])
        string mySql = this.buildREPLACE(parsedSql["REPLACE"]);
        mySql ~= parsedSql.isSet("VALUES") ? " " ~ this.buildVALUES(parsedSql["VALUES"]) : "";
        mySql ~= parsedSql.isSet("SET") ? " " ~ this.buildSET(parsedSql["SET"]) : "";
        mySql ~= parsedSql.isSet("SELECT") ? " " ~ this.buildSELECT(parsedSql) : "";
        
        return mySql;
    }
}
