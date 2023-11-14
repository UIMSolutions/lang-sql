
/**
 * ColumnDefinitionBuilder.php
 *
 * Builds the column definition statement part of CREATE TABLE.
 */

module langs.sql.PHPSQLParser.builders.columns.definition;

import lang.sql;

@safe:
/**
 * This class : the builder for the columndefinition statement part 
 * of CREATE TABLE. You can overwrite all functions to achieve another handling.
 */
class ColumnDefinitionBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildColumnType($parsed) {
        auto myBuilder = new ColumnTypeBuilder();
        return $builder.build($parsed);
    }

   auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLDEF) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildColumnType($v);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
