module langs.sql.sqlparsers.builders.tableexpression;

import lang.sql;

@safe:

/**
 * Builds the table name/join options. 
 * This class : the builder for the table name and join options. 
 */
class TableExpressionBuilder : ISqlBuilder {

    protected string buildFROM(Json parsedSql) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildAlias(Json parsedSql) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildJoin(Json parsedSql) {
        auto myBuilder = new JoinBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildRefType(Json parsedSql) {
        auto myBuilder = new RefTypeBuilder();
        return myBuilder.build(parsedSql);
    }

    protected string buildRefClause(Json parsedSql) {
        auto myBuilder = new RefClauseBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql, $index = 0) {
        if (!parsedSql.isExpressionType("TABLE_EXPRESSION")) {
            return "";
        }
        
        string mySql = substr(this.buildFROM(parsedSql["sub_tree"]), 5); // remove FROM keyword
        mySql = "(" ~ mySql ~ ")";
        mySql ~= this.buildAlias(parsedSql);

        if ($index != 0) {
            mySql = this.buildJoin(parsedSql["join_type"]) ~ mySql;
            mySql ~= this.buildRefType(parsedSql["ref_type"]);
            mySql ~= parsedSql["ref_clause"] == false ? "" : this.buildRefClause(parsedSql["ref_clause"]);
        }
        return mySql;
    }
}
