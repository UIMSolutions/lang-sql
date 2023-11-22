module langs.sql.sqlparsers.builders.columns.type;

import lang.sql;

@safe:

/**
 * Builds the column type statement part of CREATE TABLE. */
 * This class : the builder for the column type statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ColumnTypeBuilder : ISqlBuilder {

    protected auto buildColumnTypeBracketExpression($parsed) {
        auto myBuilder = new ColumnTypeBracketExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildDataType($parsed) {
        auto myBuilder = new DataTypeBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildDefaultValue($parsed) {
        auto myBuilder = new DefaultValueBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildCharacterSet($parsed) {
        if (!$parsed["expr_type"].isExpressionType("CHARSET")) {
            return "";
        }
        return $parsed["base_expr"];
    }

    protected auto buildCollation($parsed) {
        if (!$parsed["expr_type"].isExpressionType("COLLATE")) {
            return "";
        }
        return $parsed["base_expr"];
    }

    protected auto buildComment($parsed) {
        if (!$parsed["expr_type"].isExpressionType("COMMENT")) {
            return "";
        }
        return $parsed["base_expr"];
    }

    string build(Json parsedSQL) {
        if (!$parsed["expr_type"].isExpressionType("COLUMN_TYPE")) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildDataType(myValue);
            mySql ~= this.buildColumnTypeBracketExpression(myValue);
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildDefaultValue(myValue);
            mySql ~= this.buildCharacterSet(myValue);
            mySql ~= this.buildCollation(myValue);
            mySql ~= this.buildComment(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE column-type subtree", myKey, myValue, "expr_type");
            }
    
            mySql ~= " ";
        }
    
        return substr(mySql, 0, -1);
    }
    
}
