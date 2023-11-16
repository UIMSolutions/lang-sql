module langs.sql.PHPSQLParser.builders.selects.statement;

/**
 * Builds the SELECT statement 
 * This class : the builder for the whole Select statement. You can overwrite
 * all functions to achieve another handling. */
class SelectStatementBuilder : ISqlBuilder {

    protected auto buildSELECT($parsed) {
        auto myBuilder = new SelectBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildFROM($parsed) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildWHERE($parsed) {
        auto myBuilder = new WhereBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildGROUP($parsed) {
        auto myBuilder = new GroupByBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildHAVING($parsed) {
        auto myBuilder = new HavingBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildORDER($parsed) {
        auto myBuilder = new OrderByBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildLIMIT($parsed) {
        auto myBuilder = new LimitBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildUNION($parsed) {
    	auto myBuilder = new UnionStatementBuilder();
    	return myBuilder.build($parsed);
    }
    
    protected auto buildUNIONALL($parsed) {
    	auto myBuilder = new UnionAllStatementBuilder();
    	return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        string mySql = "";
        if ($parsed.isSet("SELECT")) {
            mySql ~= this.buildSELECT($parsed["SELECT"]);
        }
        if ($parsed.isSet("FROM")) {
            mySql ~= " " ~ this.buildFROM($parsed["FROM"]);
        }
        if ($parsed.isSet("WHERE")) {
            mySql ~= " " ~ this.buildWHERE($parsed["WHERE"]);
        }
        if ($parsed.isSet("GROUP")) {
            mySql ~= " " ~ this.buildGROUP($parsed["GROUP"]);
        }
        if ($parsed.isSet("HAVING")) {
            mySql ~= " " ~ this.buildHAVING($parsed["HAVING"]);
        }
        if ($parsed.isSet("ORDER")) {
            mySql ~= " " ~ this.buildORDER($parsed["ORDER"]);
        }
        if ($parsed.isSet("LIMIT")) {
            mySql ~= " " ~ this.buildLIMIT($parsed["LIMIT"]);
        }       
        if ($parsed.isSet("UNION")) {
            mySql ~= " " ~ this.buildUNION($parsed);
        }
        if ($parsed.isSet("UNION ALL")) {
        	mySql ~= " " ~ this.buildUNIONALL($parsed);
        }
        return mySql;
    }

}
