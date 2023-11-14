
/**
 * InsertColumnListBuilder.php
 *
 * Builds column-list parts of INSERT statements.

 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for column-list parts of INSERT statements. 
 * You can overwrite all functions to achieve another handling.
 */
class InsertColumnListBuilder : ISqlBuilder {

    protected auto buildColumn($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_LIST) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColumn($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('INSERT column-list subtree', $k, $v, 'expr_type');
            }

            mySql  ~= ", ";
        } 
        return "(" . substr(mySql, 0, -2) . ")";
    }

}
