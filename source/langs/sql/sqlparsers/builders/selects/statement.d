module langs.sql.sqlparsers.builders.selects.statement;

/**
 * Builds the SELECT statement 
 * This class : the builder for the whole Select statement. You can overwrite
 * all functions to achieve another handling. */
class SelectStatementBuilder : ISqlBuilder {

    protected auto buildSELECT(parsedSQL) {
        auto myBuilder = new SelectBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildFROM(parsedSQL) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildWHERE(parsedSQL) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildGROUP(parsedSQL) {
        auto myBuilder = new GroupByBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildHAVING(parsedSQL) {
        auto myBuilder = new HavingBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildORDER(parsedSQL) {
        auto myBuilder = new OrderByBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildLIMIT(parsedSQL) {
        auto myBuilder = new LimitBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildUNION(parsedSQL) {
    	auto myBuilder = new UnionStatementBuilder();
    	return myBuilder.build(parsedSQL);
    }
    
    protected auto buildUNIONALL(parsedSQL) {
    	auto myBuilder = new UnionAllStatementBuilder();
    	return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = "";
        if (parsedSQL.isSet("SELECT")) {
            mySql ~= this.buildSELECT(parsedSQL["SELECT"]);
        }
        if (parsedSQL.isSet("FROM")) {
            mySql ~= " " ~ this.buildFROM(parsedSQL["FROM"]);
        }
        if (parsedSQL.isSet("WHERE")) {
            mySql ~= " " ~ this.buildWHERE(parsedSQL["WHERE"]);
        }
        if (parsedSQL.isSet("GROUP")) {
            mySql ~= " " ~ this.buildGROUP(parsedSQL["GROUP"]);
        }
        if (parsedSQL.isSet("HAVING")) {
            mySql ~= " " ~ this.buildHAVING(parsedSQL["HAVING"]);
        }
        if (parsedSQL.isSet("ORDER")) {
            mySql ~= " " ~ this.buildORDER(parsedSQL["ORDER"]);
        }
        if (parsedSQL.isSet("LIMIT")) {
            mySql ~= " " ~ this.buildLIMIT(parsedSQL["LIMIT"]);
        }       
        if (parsedSQL.isSet("UNION")) {
            mySql ~= " " ~ this.buildUNION(parsedSQL);
        }
        if (parsedSQL.isSet("UNION ALL")) {
        	mySql ~= " " ~ this.buildUNIONALL(parsedSQL);
        }
        return mySql;
    }

}
