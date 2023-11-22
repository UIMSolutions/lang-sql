module langs.sql.sqlparsers.builders.columns.list;

import lang.sql;

@safe:

/**
 * Builds column-list parts of CREATE TABLE. 
 * This class : the builder for column-list parts of CREATE TABLE. 
 *  */
class ColumnListBuilder : ISqlBuilder {

    protected auto buildIndexColumn(parsedSql) {
        auto myBuilder = new IndexColumnBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildColumnReference(parsedSql) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql, $delim = ", ") {
        if (!parsedSql.isExpressionType("COLUMN_LIST")) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildIndexColumn(value);
            mySql ~= this.buildColumnReference(value);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE column-list subtree", myKey, myValue, "expr_type");
            }

            mySql ~= $delim;
        }
        return "(" ~ substr(mySql, 0, -strlen($delim)) ~ ")";
    }

}
