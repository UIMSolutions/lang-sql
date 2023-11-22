module langs.sql.sqlparsers.builders.drop.expression;

import lang.sql;

@safe:

/**
 * Builds the object list of a DROP statement. 
 * This class : the builder for the object list of a DROP statement.
 * You can overwrite all functions to achieve another handling. */
class DropExpressionBuilder : ISqlBuilder {

    protected auto buildTable(parsedSQL, $index) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSQL, $index);
    }

    protected auto buildDatabase(parsedSQL) {
        auto myBuilder = new DatabaseBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildSchema(parsedSQL) {
        auto myBuilder = new SchemaBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildTemporaryTable(parsedSQL) {
        auto myBuilder = new TempTableBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    protected auto buildView(parsedSQL) {
        auto myBuilder = new ViewBuilder();
        return myBuilder.build(parsedSQL);
    }
    
    string build(Json parsedSQL) {
        if (parsedSQL["expr_type"] !.isExpressionType(EXPRESSION) { return ""; }

        string mySql = "";
        foreach (myKey, myValue; parsedSQL["sub_tree"]) {
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
