module langs.sql.sqlparsers.builders.columns.type;

import lang.sql;

@safe:

/**
 * Builds the column type statement part of CREATE TABLE. */
 * This class : the builder for the column type statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ColumnTypeBuilder : ISqlBuilder {

    protected auto buildColumnTypeBracketExpression(parsedSQL) {
        auto myBuilder = new ColumnTypeBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildDataType(parsedSQL) {
        auto myBuilder = new DataTypeBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildDefaultValue(parsedSQL) {
        auto myBuilder = new DefaultValueBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildCharacterSet(parsedSQL) {
        if (!parsedSQL["expr_type"].isExpressionType("CHARSET")) {
            return "";
        }
        return parsedSQL["base_expr"];
    }

    protected auto buildCollation(parsedSQL) {
        if (!parsedSQL["expr_type"].isExpressionType("COLLATE")) {
            return "";
        }
        return parsedSQL["base_expr"];
    }

    protected auto buildComment(parsedSQL) {
        if (!parsedSQL["expr_type"].isExpressionType("COMMENT")) {
            return "";
        }
        return parsedSQL["base_expr"];
    }

    string build(Json parsedSQL) {
        if (!parsedSQL["expr_type"].isExpressionType("COLUMN_TYPE")) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
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
