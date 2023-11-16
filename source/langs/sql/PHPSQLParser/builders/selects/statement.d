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
        if (isset($parsed["SELECT"])) {
            mySql  ~= this.buildSELECT($parsed["SELECT"]);
        }
        if (isset($parsed["FROM"])) {
            mySql  ~= " "~ this.buildFROM($parsed["FROM"]);
        }
        if (isset($parsed["WHERE"])) {
            mySql  ~= " "~ this.buildWHERE($parsed["WHERE"]);
        }
        if (isset($parsed["GROUP"])) {
            mySql  ~= " "~ this.buildGROUP($parsed["GROUP"]);
        }
        if (isset($parsed["HAVING"])) {
            mySql  ~= " "~ this.buildHAVING($parsed["HAVING"]);
        }
        if (isset($parsed["ORDER"])) {
            mySql  ~= " "~ this.buildORDER($parsed["ORDER"]);
        }
        if (isset($parsed["LIMIT"])) {
            mySql  ~= " "~ this.buildLIMIT($parsed["LIMIT"]);
        }       
        if (isset($parsed["UNION"])) {
            mySql  ~= " "~ this.buildUNION($parsed);
        }
        if (isset($parsed["UNION ALL"])) {
        	mySql  ~= " "~ this.buildUNIONALL($parsed);
        }
        return mySql;
    }

}
