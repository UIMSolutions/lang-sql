module langs.sql.PHPSQLParser.builders.from;

import lang.sql;

@safe:

/**
 * Builds the FROM statement
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
        auto string mySql = "";
        if (array_key_exists("UNION ALL", $parsed) || array_key_exists("UNION", $parsed)) {
            foreach ($union_type : $outer_v; $parsed) {
                $first = true;

                foreach ($item; $outer_v) {
                    if (!$first) {
                        mySql ~= " $union_type ";
                    }
                    else {
                        $first = false;
                    }

                    $select_builder = new SelectStatementBuilder();

                    size_t oldSqlLength = mySql.length;
                    mySql ~= $select_builder.build($item);

                    if (oldSqlLength == mySql.length) { // No change
                        throw new UnableToCreateSQLException('FROM', $union_type, $outer_v, "expr_type");
                    }
                }
            }
        }
        else {
            foreach (myKey, myValue; $parsed) {
                size_t oldSqlLength = mySql.length;
                mySql ~= this.buildTable(myValue, $k);
                mySql ~= this.buildTableExpression(myValue, $k);
                mySql ~= this.buildSubquery(myValue, $k);

                if (oldSqlLength == mySql.length) { // No change
                    throw new UnableToCreateSQLException('FROM', myKey, myValue, "expr_type");
                }
            }
        }
        return "FROM " ~ mySql;
    }
}