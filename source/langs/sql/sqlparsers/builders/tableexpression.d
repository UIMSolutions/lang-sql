module langs.sql.sqlparsers.builders.tableexpression;

import lang.sql;

@safe:

/**
 * Builds the table name/join options. 
 * This class : the builder for the table name and join options. 
 * You can overwrite all functions to achieve another handling. */
class TableExpressionBuilder : ISqlBuilder {

    protected auto buildFROM(parsedSQL) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildAlias(parsedSQL) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildJoin(parsedSQL) {
        auto myBuilder = new JoinBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildRefType(parsedSQL) {
        auto myBuilder = new RefTypeBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildRefClause(parsedSQL) {
        auto myBuilder = new RefClauseBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL, $index = 0) {
        if (!parsedSQL["expr_type"].isExpressionType("TABLE_EXPRESSION")) {
            return "";
        }
        
        string mySql = substr(this.buildFROM(parsedSQL["sub_tree"]), 5); // remove FROM keyword
        mySql = "(" ~ mySql ~ ")";
        mySql ~= this.buildAlias(parsedSQL);

        if ($index != 0) {
            mySql = this.buildJoin(parsedSQL["join_type"]) ~ mySql;
            mySql ~= this.buildRefType(parsedSQL["ref_type"]);
            mySql ~= parsedSQL["ref_clause"] == false ? "" : this.buildRefClause(parsedSQL["ref_clause"]);
        }
        return mySql;
    }
}
