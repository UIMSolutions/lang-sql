
/**
 * ShowBuilder.php
 *
 * Builds the SHOW statement.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the SHOW statement. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class ShowBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $delim) {
        $builder = new TableBuilder();
        return $builder.build($parsed, $delim);
    }

    protected auto buildFunction($parsed) {
        $builder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildProcedure($parsed) {
        $builder = new ProcedureBuilder();
        return $builder.build($parsed);
    }

    protected auto buildDatabase($parsed) {
        $builder = new DatabaseBuilder();
        return $builder.build($parsed);
    }

    protected auto buildEngine($parsed) {
        $builder = new EngineBuilder();
        return $builder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $show = $parsed["SHOW"];
        mySql = "";
        foreach ($show as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildEngine($v);
            mySql  ~= this.buildDatabase($v);
            mySql  ~= this.buildProcedure($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildTable($v, 0);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('SHOW', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }

        mySql = substr(mySql, 0, -1);
        return "SHOW " . mySql;
    }
}
