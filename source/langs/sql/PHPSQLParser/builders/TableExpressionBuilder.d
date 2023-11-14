
/**
 * TableExpressionBuilder.php
 *
 * Builds the table name/join options.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the table name and join options. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class TableExpressionBuilder : ISqlBuilder {

    protected auto buildFROM($parsed) {
        myBuilder = new FromBuilder();
        return $builder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        myBuilder = new AliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildJoin($parsed) {
        myBuilder = new JoinBuilder();
        return $builder.build($parsed);
    }

    protected auto buildRefType($parsed) {
        myBuilder = new RefTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildRefClause($parsed) {
        myBuilder = new RefClauseBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed, $index = 0) {
        if ($parsed["expr_type"] != ExpressionType::TABLE_EXPRESSION) {
            return "";
        }
        $sql = substr(this.buildFROM($parsed["sub_tree"]), 5); // remove FROM keyword
        $sql = '(' . $sql . ')';
        $sql  ~= this.buildAlias($parsed);

        if ($index != 0) {
            $sql = this.buildJoin($parsed["join_type"]) . $sql;
            $sql  ~= this.buildRefType($parsed["ref_type"]);
            $sql  ~= $parsed["ref_clause"] == false ? '' : this.buildRefClause($parsed["ref_clause"]);
        }
        return $sql;
    }
}
