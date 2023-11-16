module source.langs.sql.PHPSQLParser.builders.show.show;

import lang.sql;

@safe:

/**
 * Builds the SHOW statement. 
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class ShowBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $delim) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, $delim);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildProcedure($parsed) {
        auto myBuilder = new ProcedureBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildDatabase($parsed) {
        auto myBuilder = new DatabaseBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildEngine($parsed) {
        auto myBuilder = new EngineBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        auto $show = $parsed["SHOW"];
        
        string mySql = "";
        foreach (myKey, myValue; $show) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildEngine(myValue);
            mySql  ~= this.buildDatabase(myValue);
            mySql  ~= this.buildProcedure(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildTable(myValue, 0);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('SHOW', myKey, myValue, "expr_type");
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return "SHOW " . mySql;
    }
}
