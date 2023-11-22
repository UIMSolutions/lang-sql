module langs.sql.sqlparsers.builders.drop.expression;

import lang.sql;

@safe:

/**
 * Builds the object list of a DROP statement. 
 * This class : the builder for the object list of a DROP statement.
 * You can overwrite all functions to achieve another handling. */
class DropExpressionBuilder : ISqlBuilder {

    protected auto buildTable(parsedSql, $index) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, $index);
    }

    protected auto buildDatabase(parsedSql) {
        auto myBuilder = new DatabaseBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildSchema(parsedSql) {
        auto myBuilder = new SchemaBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildTemporaryTable(parsedSql) {
        auto myBuilder = new TempTableBuilder();
        return myBuilder.build(parsedSql);
    }
    
    protected auto buildView(parsedSql) {
        auto myBuilder = new ViewBuilder();
        return myBuilder.build(parsedSql);
    }
    
    string build(Json parsedSql) {
        if (parsedSql["expr_type"] !.isExpressionType(EXPRESSION) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSql["sub_tree"]) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildTable(myValue, 0);
            mySql ~= this.buildView(myValue);
            mySql ~= this.buildSchema(myValue);
            mySql ~= this.buildDatabase(myValue);
            mySql ~= this.buildTemporaryTable(myValue, 0);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("DROP object-list subtree", myKey, myValue, "expr_type");
            }

            mySql ~= ", ";
        }
        return substr(mySql, 0, -2);
    }
}
