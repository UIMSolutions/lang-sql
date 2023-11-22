module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds constant (String, Integer, etc.) parts.
 * This class : the builder for constants. 
 * You can overwrite all functions to achieve another handling. */
class ConstantBuilder : ISqlBuilder {

    protected auto buildAlias(parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(CONSTANT) {
            return "";
        }
        
        string mySql = parsedSql["base_expr"];
        mySql ~= this.buildAlias(parsedSql);
        return mySql;
    }
}
