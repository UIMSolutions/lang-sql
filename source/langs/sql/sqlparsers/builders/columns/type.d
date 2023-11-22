module langs.sql.sqlparsers.builders.columns.type;

import lang.sql;

@safe:

/**
 * Builds the column type statement part of CREATE TABLE. */
 * This class : the builder for the column type statement part of CREATE TABLE. 
 *  */
class ColumnTypeBuilder : ISqlBuilder {

    protected auto buildColumnTypeBracketExpression(Json parsedSql) {
        auto myBuilder = new ColumnTypeBracketExpressionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(Json parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildDataType(Json parsedSql) {
        auto myBuilder = new DataTypeBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildDefaultValue(Json parsedSql) {
        auto myBuilder = new DefaultValueBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildCharacterSet(Json parsedSql) {
        if (!parsedSql.isExpressionType("CHARSET")) {
            return "";
        }
        return parsedSql["base_expr"];
    }

    protected auto buildCollation(Json parsedSql) {
        if (!parsedSql.isExpressionType("COLLATE")) {
            return "";
        }
        return parsedSql["base_expr"];
    }

    protected auto buildComment(Json parsedSql) {
        if (!parsedSql.isExpressionType("COMMENT")) {
            return "";
        }
        return parsedSql["base_expr"];
    }

    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType("COLUMN_TYPE")) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
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
