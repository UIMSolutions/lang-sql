
module langs.sql.sqlparsers.builders.tablebracketexpression;

import lang.sql;

@safe:

/**
 * Builds the table expressions within the create definitions of CREATE TABLE. */
 * This class : the builder for the table expressions 
 * within the create definitions of CREATE TABLE. 
 */
class TableBracketExpressionBuilder : ISqlBuilder {

    protected auto buildColDef(Json parsedSql) {
        auto myBuilder = new ColumnDefinitionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildPrimaryKey(Json parsedSql) {
        auto myBuilder = new PrimaryKeyBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildForeignKey(Json parsedSql) {
        auto myBuilder = new ForeignKeyBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildCheck(Json parsedSql) {
        auto myBuilder = new CheckBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildLikeExpression(Json parsedSql) {
        auto myBuilder = new LikeExpressionBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildIndexKey(Json parsedSql) {
        auto myBuilder = new IndexKeyBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildUniqueIndex(Json parsedSql) {
        auto myBuilder = new UniqueIndexBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildFulltextIndex(Json parsedSql) {
        auto myBuilder = new FulltextIndexBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        if (!parsedSql.isExpressionType(BRACKET_EXPRESSION) {
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
