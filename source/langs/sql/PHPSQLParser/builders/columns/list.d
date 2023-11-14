
/**
 * ColumnListBuilder.php
 *
 * Builds column-list parts of CREATE TABLE. */

module langs.sql.PHPSQLParser.builders.columns.list;

import lang.sql;

@safe:

/**
 * This class : the builder for column-list parts of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class ColumnListBuilder : ISqlBuilder {

    protected auto buildIndexColumn($parsed) {
        auto myBuilder = new IndexColumnBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnReference($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }
    
    string build(array $parsed, $delim = ', ') {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_LIST) {
            return "";
        }

        string mySql = "";
        foreach (key, value; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildIndexColumn(value);
            mySql  ~= this.buildColumnReference(value);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('CREATE TABLE column-list subtree', key, value, 'expr_type');
            }

            mySql  ~= $delim;
        }
        return '(' . substr(mySql, 0, -strlen($delim)) . ')';
    }

}
