
module langs.sql.sqlparsers.builders.tablebracketexpression;

import lang.sql;

@safe:

/**
 * Builds the table expressions within the create definitions of CREATE TABLE. */
 * This class : the builder for the table expressions 
 * within the create definitions of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class TableBracketExpressionBuilder : ISqlBuilder {

    protected auto buildColDef(parsedSql) {
        auto myBuilder = new ColumnDefinitionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildPrimaryKey(parsedSql) {
        auto myBuilder = new PrimaryKeyBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildForeignKey(parsedSql) {
        auto myBuilder = new ForeignKeyBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildCheck(parsedSql) {
        auto myBuilder = new CheckBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildLikeExpression(parsedSql) {
        auto myBuilder = new LikeExpressionBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildIndexKey(parsedSql) {
        auto myBuilder = new IndexKeyBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildUniqueIndex(parsedSql) {
        auto myBuilder = new UniqueIndexBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildFulltextIndex(parsedSql) {
        auto myBuilder = new FulltextIndexBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(BRACKET_EXPRESSION) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildColDef(myValue);
            mySql ~= this.buildPrimaryKey(myValue);
            mySql ~= this.buildCheck(myValue);
            mySql ~= this.buildLikeExpression(myValue);
            mySql ~= this.buildForeignKey(myValue);
            mySql ~= this.buildIndexKey(myValue);
            mySql ~= this.buildUniqueIndex(myValue);
            mySql ~= this.buildFulltextIndex(myValue);
                        
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("CREATE TABLE create-def expression subtree", myKey, myValue, "expr_type");
            }

            mySql ~= ", ";
        }

        mySql = " (" ~ substr(mySql, 0, -2) ~ ")";
        return mySql;
    }
    
}
