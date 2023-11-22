module langs.sql.sqlparsers.builders.columns.reference;

import lang.sql;

@safe:

class ColumnReferenceBuilder : ISqlBuilder {

    protected auto buildAlias(parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (!parsedSql["expr_type"].isExpressionType("COLREF") {
            return "";
        }
        
        string mySql = parsedSql["base_expr"];
        mySql ~= this.buildAlias(parsedSql);
        return mySql;
    }
}
