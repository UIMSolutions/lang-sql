
module langs.sql.sqlparsers.builders.subquery;

import lang.sql;

@safe:

/**
 * Builds the statements for sub-queries. */
 * This class : the builder for sub-queries. 
 *  */
class SubQueryBuilder : ISqlBuilder {

    protected auto buildRefClause(parsedSql) {
        auto myBuilder = new RefClauseBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildRefType(parsedSql) {
        auto myBuilder = new RefTypeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildJoin(parsedSql) {
        auto myBuilder = new JoinBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildAlias(parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSelectStatement(parsedSql) {
        auto myBuilder = new SelectStatementBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql, $index = 0) {
        if (parsedSql["expr_type"] !.isExpressionType(SUBQUERY) {
            return "";
        }

        // TODO: should we add a numeric level (0) between sub_tree and SELECT?
        string mySql = this.buildSelectStatement(parsedSql["sub_tree"]);
        mySql = "(" ~ mySql ~ ")";
        mySql ~= this.buildAlias(parsedSql);

        if ($index != 0) {
            mySql = this.buildJoin(parsedSql["join_type"]) . mySql;
            mySql ~= this.buildRefType(parsedSql["ref_type"]);
            mySql ~= parsedSql["ref_clause"] == false ? "" : this.buildRefClause(parsedSql["ref_clause"]);
        }
        return mySql;
    }
}
