module langs.sql.PHPSQLParser.builders.tableexpression;

import lang.sql;

@safe:

/**
 * Builds the table name/join options. 
 * This class : the builder for the table name and join options. 
 * You can overwrite all functions to achieve another handling. */
class TableExpressionBuilder : ISqlBuilder {

    protected auto buildFROM($parsed) {
        auto myBuilder = new FromBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildAlias($parsed) {
        auto myBuilder = new AliasBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildJoin($parsed) {
        auto myBuilder = new JoinBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildRefType($parsed) {
        auto myBuilder = new RefTypeBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildRefClause($parsed) {
        auto myBuilder = new RefClauseBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed, $index = 0) {
        if (!$parsed["expr_type"].isExpressionType("TABLE_EXPRESSION")) {
            return "";
        }
        
        string mySql = substr(this.buildFROM($parsed["sub_tree"]), 5); // remove FROM keyword
        mySql = "(" ~ mySql ~ ")";
        mySql  ~= this.buildAlias($parsed);

        if ($index != 0) {
            mySql = this.buildJoin($parsed["join_type"]) ~ mySql;
            mySql  ~= this.buildRefType($parsed["ref_type"]);
            mySql  ~= $parsed["ref_clause"] == false ? "" : this.buildRefClause($parsed["ref_clause"]);
        }
        return mySql;
    }
}
