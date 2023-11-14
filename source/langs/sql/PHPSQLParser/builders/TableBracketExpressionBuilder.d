
/**
 * TableBracketExpressionBuilder.php
 *
 * Builds the table expressions within the create definitions of CREATE TABLE.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the table expressions 
 * within the create definitions of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class TableBracketExpressionBuilder : ISqlBuilder {

    protected auto buildColDef($parsed) {
        myBuilder = new ColumnDefinitionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildPrimaryKey($parsed) {
        myBuilder = new PrimaryKeyBuilder();
        return $builder.build($parsed);
    }

    protected auto buildForeignKey($parsed) {
        myBuilder = new ForeignKeyBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildCheck($parsed) {
        myBuilder = new CheckBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildLikeExpression($parsed) {
        myBuilder = new LikeExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildIndexKey($parsed) {
        myBuilder = new IndexKeyBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildUniqueIndex($parsed) {
        myBuilder = new UniqueIndexBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildFulltextIndex($parsed) {
        myBuilder = new FulltextIndexBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::BRACKET_EXPRESSION) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildColDef($v);
            mySql  ~= this.buildPrimaryKey($v);
            mySql  ~= this.buildCheck($v);
            mySql  ~= this.buildLikeExpression($v);
            mySql  ~= this.buildForeignKey($v);
            mySql  ~= this.buildIndexKey($v);
            mySql  ~= this.buildUniqueIndex($v);
            mySql  ~= this.buildFulltextIndex($v);
                        
            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('CREATE TABLE create-def expression subtree', $k, $v, 'expr_type');
            }

            mySql  ~= ", ";
        }

        mySql = " (" . substr(mySql, 0, -2) . ")";
        return mySql;
    }
    
}
