module langs.sql.sqlparsers.builders.insert.InsertStatementBuilder;

/**
 * Builds the INSERT statement
 * This class : the builder for the whole Insert statement. You can overwrite
 * all functions to achieve another handling. */
class InsertStatementBuilder : ISqlBuilder {

    protected auto buildVALUES(parsedSQL) {
        auto myBuilder = new ValuesBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildINSERT(parsedSQL) {
        auto myBuilder = new InsertBuilder();
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
        // TODO: are there more than one tables possible (like [INSERT][1])
        string mySql = this.buildINSERT(parsedSQL["INSERT"]);
        if (parsedSQL.isSet("VALUES")) {
            mySql ~= " " ~ this.buildVALUES(parsedSQL["VALUES"]);
        }
        if (parsedSQL.isSet("SET")) {
            mySql ~= " " ~ this.buildSET(parsedSQL["SET"]);
        }
        if (parsedSQL.isSet("SELECT")) {
            mySql ~= " " ~ this.buildSELECT(parsedSQL);
        }
        return mySql;
    }
}
