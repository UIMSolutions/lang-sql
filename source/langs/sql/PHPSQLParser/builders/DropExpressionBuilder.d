
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
        myBuilder = new TableBuilder();
        return $builder.build($parsed, $index);
    }

    protected auto buildDatabase($parsed) {
        myBuilder = new DatabaseBuilder();
        return $builder.build($parsed);
    }

    protected auto buildSchema($parsed) {
        myBuilder = new SchemaBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildTemporaryTable($parsed) {
        myBuilder = new TempTableBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildView($parsed) {
        myBuilder = new ViewBuilder();
        return $builder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildTable($v, 0);
            mySql  ~= this.buildView($v);
            mySql  ~= this.buildSchema($v);
            mySql  ~= this.buildDatabase($v);
            mySql  ~= this.buildTemporaryTable($v, 0);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('DROP object-list subtree', $k, $v, 'expr_type');
            }

            mySql  ~= ', ';
        }
        return substr(mySql, 0, -2);
    }
}
