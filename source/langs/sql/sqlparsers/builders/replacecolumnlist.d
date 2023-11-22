module langs.sql.sqlparsers.builders.replacecolumnlist;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * Builds column-list parts of REPLACE statements. 
 * This class : the builder for column-list parts of REPLACE statements. 
 * You can overwrite all functions to achieve another handling. */
class ReplaceColumnListBuilder : ISqlBuilder {

    protected auto buildColumn(parsedSQL) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(COLUMN_LIST) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColumn(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("REPLACE column-list subtree", myKey, myValue, "expr_type");
            }

            mySql ~= ", ";
        } 
        return "(" ~ substr(mySql, 0, -2) ~ ")";
    }

}
