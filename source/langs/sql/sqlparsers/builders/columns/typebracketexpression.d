module langs.sql.sqlparsers.builders.columns.typebracketexpression;

import lang.sql;

@safe:
/**
 * Builds the bracket expressions within a column type.
 * This class : the builder for bracket expressions within a column type. 
 * 
 */
class ColumnTypeBracketExpressionBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("BRACKET_EXPRESSION")) {
            return "";
        }
        string mySql = this.buildSubTree(parsedSql, ",");
        mySql = "(" ~ mySql ~ ")";
        return mySql;
    }

    protected string buildSubTree(parsedSql, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return myBuilder.build(parsedSql, $delim);
    }
}
