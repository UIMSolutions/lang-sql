
/**
 * ShowBuilder.php
 *
 * Builds the SHOW statement. */

module source.langs.sql.PHPSQLParser.builders.show;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling. */
class ShowBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $delim) {
        auto myBuilder = new TableBuilder();
        return $builder.build($parsed, $delim);
    }

    protected auto buildFunction($parsed) {
        auto myBuilder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildProcedure($parsed) {
        auto myBuilder = new ProcedureBuilder();
        return $builder.build($parsed);
    }

    protected auto buildDatabase($parsed) {
        auto myBuilder = new DatabaseBuilder();
        return $builder.build($parsed);
    }

    protected auto buildEngine($parsed) {
        auto myBuilder = new EngineBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $show = $parsed["SHOW"];
        mySql = "";
        foreach ($show as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildEngine($v);
            mySql  ~= this.buildDatabase($v);
            mySql  ~= this.buildProcedure($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildTable($v, 0);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('SHOW', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return "SHOW " . mySql;
    }
}
