
module langs.sql.sqlparsers.builders.subquery;

import lang.sql;

@safe:

/**
 * Builds the statements for sub-queries. */
 * This class : the builder for sub-queries. 
 * You can overwrite all functions to achieve another handling. */
class SubQueryBuilder : ISqlBuilder {

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
        if (parsedSQL["expr_type"] !.isExpressionType(SUBQUERY) {
            return "";
        }

        // TODO: should we add a numeric level (0) between sub_tree and SELECT?
        string mySql = this.buildSelectStatement(parsedSQL["sub_tree"]);
        mySql = "(" ~ mySql ~ ")";
        mySql ~= this.buildAlias(parsedSQL);

        if ($index != 0) {
            mySql = this.buildJoin(parsedSQL["join_type"]) . mySql;
            mySql ~= this.buildRefType(parsedSQL["ref_type"]);
            mySql ~= parsedSQL["ref_clause"] == false ? "" : this.buildRefClause(parsedSQL["ref_clause"]);
        }
        return mySql;
    }
}
