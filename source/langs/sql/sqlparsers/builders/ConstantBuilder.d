module langs.sql.parsers.builders;

import langs.sql;

@safe:

// Builds constant (String, Integer, etc.) parts.
class ConstantBuilder : ISqlBuilder {

    protected string buildAlias(Json parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("CONSTANT")) {
            return "";
        }
        
        string mySql = parsedSql.baseExpression;
       mySql ~= this.buildAlias(parsedSql);
        return mySql;
    }
}
