
/**
 * DropExpressionBuilder.php
 *
 * Builds the object list of a DROP statement. */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the object list of a DROP statement.
 * You can overwrite all functions to achieve another handling. */
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
        foreach (myKey, myValue; $parsed["sub_tree"]) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildTable(myValue, 0);
            mySql  ~= this.buildView(myValue);
            mySql  ~= this.buildSchema(myValue);
            mySql  ~= this.buildDatabase(myValue);
            mySql  ~= this.buildTemporaryTable(myValue, 0);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('DROP object-list subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= ', ';
        }
        return substr(mySql, 0, -2);
    }
}
