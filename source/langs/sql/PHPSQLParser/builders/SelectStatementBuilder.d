
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
        $builder = new SelectBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFROM($parsed) {
        $builder = new FromBuilder();
        return $builder.build($parsed);
    }

    protected auto buildWHERE($parsed) {
        $builder = new WhereBuilder();
        return $builder.build($parsed);
    }

    protected auto buildGROUP($parsed) {
        $builder = new GroupByBuilder();
        return $builder.build($parsed);
    }

    protected auto buildHAVING($parsed) {
        $builder = new HavingBuilder();
        return $builder.build($parsed);
    }

    protected auto buildORDER($parsed) {
        $builder = new OrderByBuilder();
        return $builder.build($parsed);
    }

    protected auto buildLIMIT($parsed) {
        $builder = new LimitBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildUNION($parsed) {
    	$builder = new UnionStatementBuilder();
    	return $builder.build($parsed);
    }
    
    protected auto buildUNIONALL($parsed) {
    	$builder = new UnionAllStatementBuilder();
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
