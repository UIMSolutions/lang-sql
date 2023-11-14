
/**
 * SelectStatement.php
 *
 * Builds the SELECT statement
 * 
 */

module lang.sql.parsers.builders;

/**
 * This class : the builder for the whole Select statement. You can overwrite
 * all functions to achieve another handling.
 * 
 */
class SelectStatementBuilder : ISqlBuilder {

    protected auto buildSELECT($parsed) {
        myBuilder = new SelectBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFROM($parsed) {
        myBuilder = new FromBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWHERE($parsed) {
        myBuilder = new WhereBuilder();
        return $builder.build($parsed);
    }

    protected auto buildGROUP($parsed) {
        myBuilder = new GroupByBuilder();
        return $builder.build($parsed);
    }

    protected auto buildHAVING($parsed) {
        myBuilder = new HavingBuilder();
        return $builder.build($parsed);
    }

    protected auto buildORDER($parsed) {
        myBuilder = new OrderByBuilder();
        return $builder.build($parsed);
    }

    protected auto buildLIMIT($parsed) {
        myBuilder = new LimitBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildUNION($parsed) {
    	myBuilder = new UnionStatementBuilder();
    	return $builder.build($parsed);
    }
    
    protected auto buildUNIONALL($parsed) {
    	myBuilder = new UnionAllStatementBuilder();
    	return $builder.build($parsed);
    }

    auto build(array $parsed) {
        mySql = "";
        if (isset($parsed["SELECT"])) {
            mySql  ~= this.buildSELECT($parsed["SELECT"]);
        }
        if (isset($parsed["FROM"])) {
            mySql  ~= " " . this.buildFROM($parsed["FROM"]);
        }
        if (isset($parsed["WHERE"])) {
            mySql  ~= " " . this.buildWHERE($parsed["WHERE"]);
        }
        if (isset($parsed["GROUP"])) {
            mySql  ~= " " . this.buildGROUP($parsed["GROUP"]);
        }
        if (isset($parsed["HAVING"])) {
            mySql  ~= " " . this.buildHAVING($parsed["HAVING"]);
        }
        if (isset($parsed["ORDER"])) {
            mySql  ~= " " . this.buildORDER($parsed["ORDER"]);
        }
        if (isset($parsed["LIMIT"])) {
            mySql  ~= " " . this.buildLIMIT($parsed["LIMIT"]);
        }       
        if (isset($parsed["UNION"])) {
            mySql  ~= " " . this.buildUNION($parsed);
        }
        if (isset($parsed["UNION ALL"])) {
        	mySql  ~= " " . this.buildUNIONALL($parsed);
        }
        return mySql;
    }

}
