module langs.sql.sqlparsers.builders.show.show;

import lang.sql;

@safe:

/**
 * Builds the SHOW statement. 
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class ShowBuilder : ISqlBuilder {

    protected auto buildTable(parsedSQL, $delim) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSQL, $delim);
    }

    protected auto buildFunction(parsedSQL) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildProcedure(parsedSQL) {
        auto myBuilder = new ProcedureBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildDatabase(parsedSQL) {
        auto myBuilder = new DatabaseBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildEngine(parsedSQL) {
        auto myBuilder = new EngineBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildConstant(parsedSQL) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildReserved(parsedSQL) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        auto $show = parsedSQL["SHOW"];
        
        string mySql = "";
        foreach (myKey, myValue; $show) {
            size_t oldSqlLength = mySql.length;
            mySql ~= this.buildReserved(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildEngine(myValue);
            mySql ~= this.buildDatabase(myValue);
            mySql ~= this.buildProcedure(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildTable(myValue, 0);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException("SHOW", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return "SHOW " . mySql;
    }
}
