
/**
 * ColumnDefinitionBuilder.php
 *
 * Builds the column definition statement part of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the columndefinition statement part 
 * of CREATE TABLE. You can overwrite all functions to achieve another handling.
 * 
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
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildColumnType($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
