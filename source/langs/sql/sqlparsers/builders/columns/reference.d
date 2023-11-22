module langs.sql.sqlparsers.builders.columns.reference;

import lang.sql;

@safe:

class ColumnReferenceBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build($parsed);
    }

    string build(auto[string] parsedSQL) {
        if (!$parsed["expr_type"].isExpressionType("COLREF") {
            return "";
        }
        
        string mySql = $parsed["base_expr"];
        mySql ~= this.buildAlias($parsed);
        return mySql;
    }
}
