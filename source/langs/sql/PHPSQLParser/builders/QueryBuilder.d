
/**
 * QueryBuilder.php
 *
 * Builds the SELECT statements within parentheses.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for queries within parentheses (no subqueries). 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class QueryBuilder : ISqlBuilder {

    protected auto buildRefClause($parsed) {
        auto myBuilder = new RefClauseBuilder();
        return $builder.build($parsed);
    }

    protected auto buildRefType($parsed) {
        auto myBuilder = new RefTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildJoin($parsed) {
        auto myBuilder = new JoinBuilder();
        return $builder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSelectStatement($parsed) {
        auto myBuilder = new SelectStatementBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed, $index = 0) {
        if ($parsed["expr_type"] != ExpressionType::QUERY) {
            return "";
        }

        // TODO: should we add a numeric level (0) between sub_tree and SELECT?
        $sql = this.buildSelectStatement($parsed["sub_tree"]);
        $sql  ~= this.buildAlias($parsed);

        if ($index != 0) {
            $sql = this.buildJoin($parsed["join_type"]) . $sql;
            $sql  ~= this.buildRefType($parsed["ref_type"]);
            $sql  ~= $parsed["ref_clause"] == false ? '' : this.buildRefClause($parsed["ref_clause"]);
        }
        return $sql;
    }
}
