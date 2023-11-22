module langs.sql.sqlparsers.builders.columns.typebracketexpression;

import lang.sql;

@safe:
/**
 * Builds the bracket expressions within a column type.
 * This class : the builder for bracket expressions within a column type. 
 * You can overwrite all functions to achieve another handling.
 */
class ColumnTypeBracketExpressionBuilder : ISqlBuilder {

    protected string buildSubTree(parsedSQL, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return myBuilder.build(parsedSQL, $delim);
    }

    string build(Json parsedSQL) {
        if (!parsedSQL["expr_type"].isExpressionType("BRACKET_EXPRESSION")) {
            return "";
        }
        string mySql = this.buildSubTree(parsedSQL, ",");
        mySql = "(" ~ mySql ~ ")";
        return mySql;
    }
}
