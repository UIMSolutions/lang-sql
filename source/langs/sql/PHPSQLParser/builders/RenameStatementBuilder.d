
/**
 * RenameStatement.php
 *
 * Builds the RENAME statement
 */

module lang.sql.parsers.builders;
use SqlParser\exceptions\UnableToCreateSQLException;

/**
 * This class : the builder for the RENAME statement. 
 * You can overwrite all functions to achieve another handling.
 */
class RenameStatementBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
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
        mySql = "";
        foreach ($rename["sub_tree"] as $k => $v) {
            $len = strlen(mySql);
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.processSourceAndDestTable($v);

            if ($len == strlen(mySql)) {
                throw new UnableToCreateSQLException('RENAME subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        mySql = trim('RENAME ' . mySql);
        return (substr(mySql, -1) == ',' ? substr(mySql, 0, -1) : mySql);
    }
}

?>
