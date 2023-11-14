
/**
 * FromBuilder.php
 *
 * Builds the FROM statement
 * */

module source.langs.sql.PHPSQLParser.builders.from;

import lang.sql;

@safe:

/**
 * This class : the builder for the [FROM] part. You can overwrite
 * all functions to achieve another handling.
 */
class FromBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $key) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build($parsed, $key);
    }

    protected auto buildTableExpression($parsed, $key) {
        auto myBuilder = new TableExpressionBuilder();
        return myBuilder.build($parsed, $key);
    }

    protected auto buildSubQuery($parsed, $key) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build($parsed, $key);
    }

    string build(array $parsed) {
        auto auto mySql = "";
        if (array_key_exists("UNION ALL", $parsed) || array_key_exists("UNION", $parsed)) {
            foreach ($parsed as $union_type :  $outer_v) {
                $first = true;

                foreach ($outer_v as $item) {
                    if (!$first) {
                        mySql  ~= " $union_type ";
                    }
                    else {
                        $first = false;
                    }

                    $select_builder = new SelectStatementBuilder();

                    auto oldSqlLength = mySql.length;
                    mySql  ~= $select_builder.build($item);

                    if (oldSqlLength == mySql.length) { // No change
                        throw new UnableToCreateSQLException('FROM', $union_type, $outer_v, 'expr_type');
                    }
                }
            }
        }
        else {
            foreach (myKey, myValue; $parsed) {
                auto oldSqlLength = mySql.length;
                mySql  ~= this.buildTable($v, $k);
                mySql  ~= this.buildTableExpression($v, $k);
                mySql  ~= this.buildSubquery($v, $k);

                if (oldSqlLength == mySql.length) { // No change
                    throw new UnableToCreateSQLException('FROM', $k, $v, 'expr_type');
                }
            }
        }
        return "FROM " . mySql;
    }
}
