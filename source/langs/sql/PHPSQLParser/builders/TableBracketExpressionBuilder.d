
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
 
 
 *  
 */
class TableBracketExpressionBuilder : ISqlBuilder {

    protected auto buildColDef($parsed) {
        $builder = new ColumnDefinitionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildPrimaryKey($parsed) {
        $builder = new PrimaryKeyBuilder();
        return $builder.build($parsed);
    }

    protected auto buildForeignKey($parsed) {
        $builder = new ForeignKeyBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildCheck($parsed) {
        $builder = new CheckBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildLikeExpression($parsed) {
        $builder = new LikeExpressionBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildIndexKey($parsed) {
        $builder = new IndexKeyBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildUniqueIndex($parsed) {
        $builder = new UniqueIndexBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildFulltextIndex($parsed) {
        $builder = new FulltextIndexBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::BRACKET_EXPRESSION) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildColDef($v);
            $sql  ~= this.buildPrimaryKey($v);
            $sql  ~= this.buildCheck($v);
            $sql  ~= this.buildLikeExpression($v);
            $sql  ~= this.buildForeignKey($v);
            $sql  ~= this.buildIndexKey($v);
            $sql  ~= this.buildUniqueIndex($v);
            $sql  ~= this.buildFulltextIndex($v);
                        
            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('CREATE TABLE create-def expression subtree', $k, $v, 'expr_type');
            }

            $sql  ~= ", ";
        }

        $sql = " (" . substr($sql, 0, -2) . ")";
        return $sql;
    }
    
}
