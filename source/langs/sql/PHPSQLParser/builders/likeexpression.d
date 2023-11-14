module source.langs.sql.PHPSQLParser.builders.likeexpression;

import lang.sql;

@safe:

/**
 * Builds the LIKE keyword within parenthesis. 
 * This class : the builder for the (LIKE) keyword within a 
 * CREATE TABLE statement. There are difference to LIKE (without parenthesis), 
 * the latter is a top-level element of the output array.
 * You can overwrite all functions to achieve another handling. */
class LikeExpressionBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $index) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, $index);
    }

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::LIKE) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k :  $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildTable($v, 0);

            if (oldSqlLength == mySql.length) { // No change
                throw new UnableToCreateSQLException('CREATE TABLE create-def (like) subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
