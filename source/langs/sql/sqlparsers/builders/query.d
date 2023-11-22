module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * Builds the SELECT statements within parentheses. 
 * This class : the builder for queries within parentheses (no subqueries). 
 * You can overwrite all functions to achieve another handling. */
class QueryBuilder : ISqlBuilder {

    protected auto buildRefClause(parsedSQL) {
        auto myBuilder = new RefClauseBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildRefType(parsedSQL) {
        auto myBuilder = new RefTypeBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildJoin(parsedSQL) {
        auto myBuilder = new JoinBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildAlias(parsedSQL) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSelectStatement(parsedSQL) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL, $index = 0) {
        if (parsedSQL["expr_type"] !.isExpressionType(QUERY) {
            return "";
        }

        // TODO: should we add a numeric level (0) between sub_tree and SELECT?
        $sql = this.buildSelectStatement(parsedSQL["sub_tree"]);
        $sql ~= this.buildAlias(parsedSQL);

        if ($index != 0) {
            $sql = this.buildJoin(parsedSQL["join_type"]) . $sql;
            $sql ~= this.buildRefType(parsedSQL["ref_type"]);
            $sql ~= parsedSQL["ref_clause"] == false ? "" : this.buildRefClause(parsedSQL["ref_clause"]);
        }
        return $sql;
    }
}
