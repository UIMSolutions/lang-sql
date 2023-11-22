module langs.sql.sqlparsers.builders.inlist;

import lang.sql;

@safe:

/**
 * Builds lists of values for the IN statement.
 * This class : the builder list of values for the IN statement. 
 * You can overwrite all functions to achieve another handling. */
class InListBuilder : ISqlBuilder {

    protected auto buildSubTree($parsed, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return myBuilder.build($parsed, $delim);
    }

    string build(Json parsedSQL) {
        if ($parsed["expr_type"] !.isExpressionType(IN_LIST) {
            return "";
        }
        string mySql = this.buildSubTree($parsed, ", ");
        return "(" ~ mySql ~ ")";
    }
}
