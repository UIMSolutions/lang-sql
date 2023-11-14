
/**
 * ReplaceColumnListBuilder.php
 *
 * Builds column-list parts of REPLACE statements. */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for column-list parts of REPLACE statements. 
 * You can overwrite all functions to achieve another handling. */
class ReplaceColumnListBuilder : ISqlBuilder {

    protected auto buildColumn($parsed) {
        auto myBuilder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COLUMN_LIST) {
            return "";
        }
        auto mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColumn(myValue);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('REPLACE column-list subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= ", ";
        } 
        return "(" . substr(mySql, 0, -2) . ")";
    }

}
