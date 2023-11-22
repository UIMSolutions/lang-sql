module langs.sql.sqlparsers.builders.columns.typebracketexpression;

import lang.sql;

@safe:
/**
 * Builds the bracket expressions within a column type.
 * This class : the builder for bracket expressions within a column type. 
 * You can overwrite all functions to achieve another handling.
 */
class ColumnTypeBracketExpressionBuilder : ISqlBuilder {

    protected string buildSubTree($parsed, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return myBuilder.build($parsed, $delim);
    }

    string build(Json parsedSQL) {
        if (!$parsed["expr_type"].isExpressionType("BRACKET_EXPRESSION")) {
            return "";
        }
        string mySql = this.buildSubTree($parsed, ",");
        mySql = "(" ~ mySql ~ ")";
        return mySql;
    }
}
