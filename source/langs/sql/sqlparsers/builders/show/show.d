module langs.sql.sqlparsers.builders.show.show;

import lang.sql;

@safe:

/**
 * Builds the SHOW statement. 
 * This class : the builder for the SHOW statement. 
 *  */
class ShowBuilder : ISqlBuilder {

    protected auto buildTable(parsedSql, $delim) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, $delim);
    }

    protected auto buildFunction(parsedSql) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildProcedure(parsedSql) {
        auto myBuilder = new ProcedureBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildDatabase(parsedSql) {
        auto myBuilder = new DatabaseBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildEngine(parsedSql) {
        auto myBuilder = new EngineBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildConstant(parsedSql) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build(parsedSql);
    }

    protected auto buildReserved(parsedSql) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build(parsedSql);
    }

    string build(Json parsedSql) {
        auto $show = parsedSql["SHOW"];
        
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
