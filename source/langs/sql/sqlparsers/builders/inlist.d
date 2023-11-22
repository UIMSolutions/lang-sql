module langs.sql.sqlparsers.builders.inlist;

import lang.sql;

@safe:

/**
 * Builds lists of values for the IN statement.
 * This class : the builder list of values for the IN statement. 
 *  */
class InListBuilder : ISqlBuilder {

    protected auto buildSubTree(parsedSql, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return myBuilder.build(parsedSql, $delim);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(IN_LIST) {
            return "";
        }
        string mySql = this.buildSubTree(parsedSql, ", ");
        return "(" ~ mySql ~ ")";
    }
}
