
/**
 * ColumnTypeBuilder.php
 *
 * Builds the column type statement part of CREATE TABLE. */

module langs.sql.PHPSQLParser.builders.columns.type;

import lang.sql;

@safe:

/**
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
        if ($parsed["expr_type"] != ExpressionType::CHARSET) {
            return "";
        }
        return $parsed["base_expr"];
    }

    protected auto buildCollation($parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLLATE) {
            return "";
        }
        return $parsed["base_expr"];
    }

    protected auto buildComment($parsed) {
        if ($parsed["expr_type"] != ExpressionType::COMMENT) {
            return "";
        }
        return $parsed["base_expr"];
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_TYPE) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k :  $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildDataType($v);
            mySql  ~= this.buildColumnTypeBracketExpression($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildDefaultValue($v);
            mySql  ~= this.buildCharacterSet($v);
            mySql  ~= this.buildCollation($v);
            mySql  ~= this.buildComment($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE column-type subtree', $k, $v, 'expr_type');
            }
    
            mySql  ~= " ";
        }
    
        return substr(mySql, 0, -1);
    }
    
}
