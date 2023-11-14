
/**
 * TableBracketExpressionBuilder.php
 *
 * Builds the table expressions within the create definitions of CREATE TABLE. */

module source.langs.sql.PHPSQLParser.builders.tablebracketexpression;

import lang.sql;

@safe:

/**
 * This class : the builder for the table expressions 
 * within the create definitions of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class TableBracketExpressionBuilder : ISqlBuilder {

    protected auto buildColDef($parsed) {
        auto myBuilder = new ColumnDefinitionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildPrimaryKey($parsed) {
        auto myBuilder = new PrimaryKeyBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildForeignKey($parsed) {
        auto myBuilder = new ForeignKeyBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildCheck($parsed) {
        auto myBuilder = new CheckBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildLikeExpression($parsed) {
        auto myBuilder = new LikeExpressionBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildIndexKey($parsed) {
        auto myBuilder = new IndexKeyBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildUniqueIndex($parsed) {
        auto myBuilder = new UniqueIndexBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildFulltextIndex($parsed) {
        auto myBuilder = new FulltextIndexBuilder();
        return myBuilder.build($parsed);
    }
    
    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::BRACKET_EXPRESSION) {
            return "";
        }
        auto mySql = "";
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildColDef(myValue);
            mySql  ~= this.buildPrimaryKey(myValue);
            mySql  ~= this.buildCheck(myValue);
            mySql  ~= this.buildLikeExpression(myValue);
            mySql  ~= this.buildForeignKey(myValue);
            mySql  ~= this.buildIndexKey(myValue);
            mySql  ~= this.buildUniqueIndex(myValue);
            mySql  ~= this.buildFulltextIndex(myValue);
                        
            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE create-def expression subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= ", ";
        }

        mySql = " (" ~ substr(mySql, 0, -2) ~ ")";
        return mySql;
    }
    
}
