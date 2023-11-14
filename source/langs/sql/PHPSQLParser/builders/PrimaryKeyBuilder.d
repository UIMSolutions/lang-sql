
/**
 * PrimaryKeyBuilder.php
 *
 * Builds the PRIMARY KEY statement part of CREATE TABLE.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the PRIMARY KEY  statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 */
class PrimaryKeyBuilder : ISqlBuilder {

    protected auto buildColumnList($parsed) {
        auto myBuilder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstraint($parsed) {
        auto myBuilder = new ConstraintBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexType($parsed) {
        auto myBuilder = new IndexTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexSize($parsed) {
        auto myBuilder = new IndexSizeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexParser($parsed) {
        auto myBuilder = new IndexParserBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::PRIMARY_KEY) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildConstraint($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildIndexType($v);
            mySql  ~= this.buildIndexSize($v);
            mySql  ~= this.buildIndexParser($v);

            if (oldSqlLength == mySql.length) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
