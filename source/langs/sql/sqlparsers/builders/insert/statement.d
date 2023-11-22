module langs.sql.sqlparsers.builders.insert.InsertStatementBuilder;

/**
 * Builds the INSERT statement
 * This class : the builder for the whole Insert statement. You can overwrite
 * all functions to achieve another handling. */
class InsertStatementBuilder : ISqlBuilder {

    protected auto buildVALUES(Json parsedSql) {
        auto myBuilder = new ValuesBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildINSERT(Json parsedSql) {
        auto myBuilder = new InsertBuilder();
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
        // TODO: are there more than one tables possible (like [INSERT][1])
        string mySql = this.buildINSERT(parsedSql["INSERT"]);
        if (parsedSql.isSet("VALUES")) {
            mySql ~= " " ~ this.buildVALUES(parsedSql["VALUES"]);
        }
        if (parsedSql.isSet("SET")) {
            mySql ~= " " ~ this.buildSET(parsedSql["SET"]);
        }
        if (parsedSql.isSet("SELECT")) {
            mySql ~= " " ~ this.buildSELECT(parsedSql);
        }
        return mySql;
    }
}
