
/**
 * RenameStatement.php
 *
 * Builds the RENAME statement */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the RENAME statement. 
 * You can overwrite all functions to achieve another handling. */
class RenameStatementBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
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
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.processSourceAndDestTable($v);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('RENAME subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        mySql = trim('RENAME ' . mySql);
        return (substr(mySql, -1) == ',' ? substr(mySql, 0, -1) : mySql);
    }
}

?>
