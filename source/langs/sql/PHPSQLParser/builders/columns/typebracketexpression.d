/**
 * ColumnTypeExpressionBuilder.php
 *
 * Builds the bracket expressions within a column type.

 */

module langs.sql.PHPSQLParser.builders.columns.typebracketexpression;

import lang.sql;

@safe:
/**
 * This class : the builder for bracket expressions within a column type. 
 * You can overwrite all functions to achieve another handling.

 */
class ColumnTypeBracketExpressionBuilder : ISqlBuilder {

    protected auto buildSubTree($parsed, $delim) {
        auto myBuilder = new SubTreeBuilder();
        return $builder.build($parsed, $delim);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] !=  = ExpressionType :  : BRACKET_EXPRESSION) {
            return "";
        }
        auto mySql = this.buildSubTree($parsed, ",");
        mySql = "(".mySql.")";
        return mySql;
    }
}
