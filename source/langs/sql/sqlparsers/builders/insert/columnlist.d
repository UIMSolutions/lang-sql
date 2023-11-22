module langs.sql.sqlparsers.builders.insert.columnlist;

import lang.sql;

@safe:

/**
 * Builds column-list parts of INSERT statements.
 * This class : the builder for column-list parts of INSERT statements. 
 *  */
class InsertColumnListBuilder : ISqlBuilder {

    protected auto buildColumn(Json parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(COLUMN_LIST) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColumn(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("INSERT column-list subtree", myKey, myValue, "expr_type");
            }

            mySql ~= ", ";
        } 

        return "(" ~ substr(mySql, 0, -2) ~ ")";
    }

}
