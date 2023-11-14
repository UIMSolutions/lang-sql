module langs.sql.PHPSQLParser.builders.columns.reference;

import lang.sql;

@safe:

class ColumnReferenceBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLREF) {
            return "";
        }
        
        auto mySql = $parsed["base_expr"];
        mySql  ~= this.buildAlias($parsed);
        return mySql;
    }
}
