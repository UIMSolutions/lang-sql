
/**
 * ShowBuilder.php
 *
 * Builds the SHOW statement.
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling.
 */
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
            $len = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildEngine($v);
            mySql  ~= this.buildDatabase($v);
            mySql  ~= this.buildProcedure($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildTable($v, 0);

            if ($len == mySql.length) {
                throw new UnableToCreateSQLException('SHOW', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return "SHOW " . mySql;
    }
}
