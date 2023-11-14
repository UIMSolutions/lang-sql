
/**
 * ReplaceColumnListBuilder.php
 *
 * Builds column-list parts of REPLACE statements.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for column-list parts of REPLACE statements. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class ReplaceColumnListBuilder : ISqlBuilder {

    protected auto buildColumn($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_LIST) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildColumn($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('REPLACE column-list subtree', $k, $v, 'expr_type');
            }

            mySql  ~= ", ";
        } 
        return "(" . substr(mySql, 0, -2) . ")";
    }

}
