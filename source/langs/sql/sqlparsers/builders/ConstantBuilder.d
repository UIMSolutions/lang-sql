module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds constant (String, Integer, etc.) parts.
 * This class : the builder for constants. 
 * You can overwrite all functions to achieve another handling. */
class ConstantBuilder : ISqlBuilder {

    protected auto buildAlias(parsedSQL) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(CONSTANT) {
            return "";
        }
        
        string mySql = parsedSQL["base_expr"];
        mySql ~= this.buildAlias(parsedSQL);
        return mySql;
    }
}
