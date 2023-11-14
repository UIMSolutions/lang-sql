
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
        $sql = "";
        foreach ($show as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildEngine($v);
            $sql  ~= this.buildDatabase($v);
            $sql  ~= this.buildProcedure($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildTable($v, 0);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('SHOW', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }

        $sql = substr($sql, 0, -1);
        return "SHOW " . $sql;
    }
}
