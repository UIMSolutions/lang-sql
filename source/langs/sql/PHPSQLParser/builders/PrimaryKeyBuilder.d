
/**
 * PrimaryKeyBuilder.php
 *
 * Builds the PRIMARY KEY statement part of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the PRIMARY KEY  statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class PrimaryKeyBuilder : ISqlBuilder {

    protected auto buildColumnList($parsed) {
        $builder = new ColumnListBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstraint($parsed) {
        $builder = new ConstraintBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexType($parsed) {
        $builder = new IndexTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexSize($parsed) {
        $builder = new IndexSizeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildIndexParser($parsed) {
        $builder = new IndexParserBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::PRIMARY_KEY) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildConstraint($v);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildColumnList($v);
            mySql  ~= this.buildIndexType($v);
            mySql  ~= this.buildIndexSize($v);
            mySql  ~= this.buildIndexParser($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE primary key subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
