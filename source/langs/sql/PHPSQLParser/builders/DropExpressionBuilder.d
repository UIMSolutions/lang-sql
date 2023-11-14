
/**
 * DropExpressionBuilder.php
 *
 * Builds the object list of a DROP statement.
 * 
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the object list of a DROP statement.
 * You can overwrite all functions to achieve another handling.
 * 
 */
class DropExpressionBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $index) {
        $builder = new TableBuilder();
        return $builder.build($parsed, $index);
    }

    protected auto buildDatabase($parsed) {
        $builder = new DatabaseBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSchema($parsed) {
        $builder = new SchemaBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildTemporaryTable($parsed) {
        $builder = new TempTableBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildView($parsed) {
        $builder = new ViewBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        $sql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildTable($v, 0);
            $sql  ~= this.buildView($v);
            $sql  ~= this.buildSchema($v);
            $sql  ~= this.buildDatabase($v);
            $sql  ~= this.buildTemporaryTable($v, 0);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('DROP object-list subtree', $k, $v, 'expr_type');
            }

            $sql  ~= ', ';
        }
        return substr($sql, 0, -2);
    }
}
