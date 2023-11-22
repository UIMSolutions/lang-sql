
module langs.sql.sqlparsers.builders.subquery;

import lang.sql;

@safe:

/**
 * Builds the statements for sub-queries. */
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

    string build(auto[string] parsedSQL, $index = 0) {
        if ($parsed["expr_type"] !.isExpressionType(SUBQUERY) {
            return "";
        }

        // TODO: should we add a numeric level (0) between sub_tree and SELECT?
        string mySql = this.buildSelectStatement($parsed["sub_tree"]);
        mySql = "(" ~ mySql ~ ")";
        mySql ~= this.buildAlias($parsed);

        if ($index != 0) {
            mySql = this.buildJoin($parsed["join_type"]) . mySql;
            mySql ~= this.buildRefType($parsed["ref_type"]);
            mySql ~= $parsed["ref_clause"] == false ? "" : this.buildRefClause($parsed["ref_clause"]);
        }
        return mySql;
    }
}
