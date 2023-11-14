
/**
 * RenameStatement.php
 *
 * Builds the RENAME statement
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the RENAME statement. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class RenameStatementBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        $builder = new ReservedBuilder();
        return $builder.build($parsed);
    }

    protected auto processSourceAndDestTable($v) {
        if (!isset($v["source"]) || !isset($v["destination"])) {
            return "";
        }
        return $v["source"]["base_expr"] . ' TO ' . $v["destination"]["base_expr"] . ',';
    }

    auto build(array $parsed) {
        $rename = $parsed["RENAME"];
        $sql = "";
        foreach ($rename["sub_tree"] as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildReserved($v);
            $sql  ~= this.processSourceAndDestTable($v);

            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('RENAME subtree', $k, $v, 'expr_type');
            }

            $sql  ~= ' ';
        }
        $sql = trim('RENAME ' . $sql);
        return (substr($sql, -1) == ',' ? substr($sql, 0, -1) : $sql);
    }
}

?>
