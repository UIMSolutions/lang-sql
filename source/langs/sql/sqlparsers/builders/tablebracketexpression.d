
module langs.sql.sqlparsers.builders.tablebracketexpression;

import lang.sql;

@safe:

/**
 * Builds the table expressions within the create definitions of CREATE TABLE. */
 * This class : the builder for the table expressions 
 * within the create definitions of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class TableBracketExpressionBuilder : ISqlBuilder {

    protected auto buildColDef(parsedSQL) {
        auto myBuilder = new ColumnDefinitionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildPrimaryKey(parsedSQL) {
        auto myBuilder = new PrimaryKeyBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildForeignKey(parsedSQL) {
        auto myBuilder = new ForeignKeyBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildCheck(parsedSQL) {
        auto myBuilder = new CheckBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildLikeExpression(parsedSQL) {
        auto myBuilder = new LikeExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildIndexKey(parsedSQL) {
        auto myBuilder = new IndexKeyBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildUniqueIndex(parsedSQL) {
        auto myBuilder = new UniqueIndexBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildFulltextIndex(parsedSQL) {
        auto myBuilder = new FulltextIndexBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(BRACKET_EXPRESSION) {
            return "";
        }
        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
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
