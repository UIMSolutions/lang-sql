module langs.sql.sqlparsers.builders.selects.statement;

/**
 * Builds the SELECT statement 
 * This class : the builder for the whole Select statement. You can overwrite
 * all functions to achieve another handling. */
class SelectStatementBuilder : ISqlBuilder {

    protected auto buildSELECT(parsedSql) {
        auto myBuilder = new SelectBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildFROM(parsedSql) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildWHERE(parsedSql) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildGROUP(parsedSql) {
        auto myBuilder = new GroupByBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildHAVING(parsedSql) {
        auto myBuilder = new HavingBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildORDER(parsedSql) {
        auto myBuilder = new OrderByBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildLIMIT(parsedSql) {
        auto myBuilder = new LimitBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildUNION(parsedSql) {
    	auto myBuilder = new UnionStatementBuilder();
    	return myBuilder.build(parsedSql);
    }
    
    protected auto buildUNIONALL(parsedSql) {
    	auto myBuilder = new UnionAllStatementBuilder();
    	return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        string mySql = "";
        if (parsedSql.isSet("SELECT")) {
            mySql ~= this.buildSELECT(parsedSql["SELECT"]);
        }
        if (parsedSql.isSet("FROM")) {
            mySql ~= " " ~ this.buildFROM(parsedSql["FROM"]);
        }
        if (parsedSql.isSet("WHERE")) {
            mySql ~= " " ~ this.buildWHERE(parsedSql["WHERE"]);
        }
        if (parsedSql.isSet("GROUP")) {
            mySql ~= " " ~ this.buildGROUP(parsedSql["GROUP"]);
        }
        if (parsedSql.isSet("HAVING")) {
            mySql ~= " " ~ this.buildHAVING(parsedSql["HAVING"]);
        }
        if (parsedSql.isSet("ORDER")) {
            mySql ~= " " ~ this.buildORDER(parsedSql["ORDER"]);
        }
        if (parsedSql.isSet("LIMIT")) {
            mySql ~= " " ~ this.buildLIMIT(parsedSql["LIMIT"]);
        }       
        if (parsedSql.isSet("UNION")) {
            mySql ~= " " ~ this.buildUNION(parsedSql);
        }
        if (parsedSql.isSet("UNION ALL")) {
        	mySql ~= " " ~ this.buildUNIONALL(parsedSql);
        }
        return mySql;
    }

}
