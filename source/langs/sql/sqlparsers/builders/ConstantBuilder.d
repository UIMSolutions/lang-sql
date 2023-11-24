module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds constant (String, Integer, etc.) parts.
 * This class : the builder for constants. 
 *  */
class ConstantBuilder : ISqlBuilder {

    protected auto buildAlias(Json parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("CONSTANT")) {
            return "";
        }
        
        string mySql = parsedSql["base_expr"];
        mySql ~= this.buildAlias(parsedSql);
        return mySql;
    }
}
