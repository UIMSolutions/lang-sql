module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds constant (String, Integer, etc.) parts.
 * This class : the builder for constants. 
 * You can overwrite all functions to achieve another handling. */
class ConstantBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build($parsed);
    }

    string build(Json parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(CONSTANT) {
            return "";
        }
        
        string mySql = $parsed["base_expr"];
        mySql ~= this.buildAlias($parsed);
        return mySql;
    }
}
