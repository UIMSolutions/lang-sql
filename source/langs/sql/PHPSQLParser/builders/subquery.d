
/**
 * SubQueryBuilder.php
 *
 * Builds the statements for sub-queries. */

module langs.sql.PHPSQLParser.builders.subquery;

import lang.sql;

@safe:

/**
 * This class : the builder for sub-queries. 
 * You can overwrite all functions to achieve another handling. */
class SubQueryBuilder : ISqlBuilder {

    protected auto buildRefClause($parsed) {
        auto myBuilder = new RefClauseBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildRefType($parsed) {
        auto myBuilder = new RefTypeBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildJoin($parsed) {
        auto myBuilder = new JoinBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSelectStatement($parsed) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build($parsed);
    }

    auto build(array $parsed, $index = 0) {
        if ($parsed["expr_type"] != ExpressionType::SUBQUERY) {
            return "";
        }

        // TODO: should we add a numeric level (0) between sub_tree and SELECT?
        $sql = this.buildSelectStatement($parsed["sub_tree"]);
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
