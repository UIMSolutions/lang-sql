module langs.sql.sqlparsers.builders.columns.reference;

import lang.sql;

@safe:

class ColumnReferenceBuilder : ISqlBuilder {

    protected auto buildAlias(parsedSQL) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (!parsedSQL["expr_type"].isExpressionType("COLREF") {
            return "";
        }
        
        string mySql = parsedSQL["base_expr"];
        mySql ~= this.buildAlias(parsedSQL);
        return mySql;
    }
}
