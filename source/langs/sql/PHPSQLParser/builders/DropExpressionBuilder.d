
/**
 * DropExpressionBuilder.php
 *
 * Builds the object list of a DROP statement.
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the object list of a DROP statement.
 * You can overwrite all functions to achieve another handling.
 */
class DropExpressionBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $index) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, $index);
    }

    protected auto buildDatabase($parsed) {
        auto myBuilder = new DatabaseBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildSchema($parsed) {
        auto myBuilder = new SchemaBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildTemporaryTable($parsed) {
        auto myBuilder = new TempTableBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildView($parsed) {
        auto myBuilder = new ViewBuilder();
        return myBuilder.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::EXPRESSION) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            $len = mySql.length;
            mySql  ~= this.buildTable($v, 0);
            mySql  ~= this.buildView($v);
            mySql  ~= this.buildSchema($v);
            mySql  ~= this.buildDatabase($v);
            mySql  ~= this.buildTemporaryTable($v, 0);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('DROP object-list subtree', $k, $v, 'expr_type');
            }

            mySql  ~= ', ';
        }
        return substr(mySql, 0, -2);
    }
}
