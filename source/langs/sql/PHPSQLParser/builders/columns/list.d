module langs.sql.PHPSQLParser.builders.columns.list;

import lang.sql;

@safe:

/**
 * Builds column-list parts of CREATE TABLE. 
 * This class : the builder for column-list parts of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ColumnListBuilder : ISqlBuilder {

    protected auto buildIndexColumn($parsed) {
        auto myBuilder = new IndexColumnBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildColumnReference($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return myBuilder.build($parsed);
    }
    
    string build(array $parsed, $delim = ', ') {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_LIST) {
            return "";
        }

        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql  ~= this.buildIndexColumn(value);
            mySql  ~= this.buildColumnReference(value);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE column-list subtree', myKey, myValue, "expr_type");
            }

            mySql  ~= $delim;
        }
        return "(" . substr(mySql, 0, -strlen($delim)) . ")";
    }

}
