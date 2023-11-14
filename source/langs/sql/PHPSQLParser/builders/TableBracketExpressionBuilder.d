
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
        auto myBuilder = new ColumnDefinitionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildPrimaryKey($parsed) {
        auto myBuilder = new PrimaryKeyBuilder();
        return $builder.build($parsed);
    }

    protected auto buildForeignKey($parsed) {
        auto myBuilder = new ForeignKeyBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildCheck($parsed) {
        auto myBuilder = new CheckBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildLikeExpression($parsed) {
        auto myBuilder = new LikeExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildIndexKey($parsed) {
        auto myBuilder = new IndexKeyBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildUniqueIndex($parsed) {
        auto myBuilder = new UniqueIndexBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildFulltextIndex($parsed) {
        auto myBuilder = new FulltextIndexBuilder();
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
