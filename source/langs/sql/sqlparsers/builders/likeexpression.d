module langs.sql.sqlparsers.builders.likeexpression;

import lang.sql;

@safe:

/**
 * Builds the LIKE keyword within parenthesis. 
 * This class : the builder for the (LIKE) keyword within a 
 * CREATE TABLE statement. There are difference to LIKE (without parenthesis), 
 * the latter is a top-level element of the output array.
 *  */
class LikeExpressionBuilder : ISqlBuilder {

    protected auto buildTable(parsedSql, $index) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, $index);
    }

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(LIKE) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildTable(myValue, 0);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE create-def (like) subtree", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
