module langs.sql.sqlparsers.builders.from;

import lang.sql;

@safe:

/**
 * Builds the FROM statement
 * This class : the builder for the [FROM] part. You can overwrite
 * all functions to achieve another handling.
 */
class FromBuilder : ISqlBuilder {

    protected auto buildTable(parsedSql, myKey) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, myKey);
    }

    protected auto buildTableExpression(parsedSql, myKey) {
        auto myBuilder = new TableExpressionBuilder();
        return myBuilder.build(parsedSql, myKey);
    }

    protected auto buildSubQuery(parsedSql, myKey) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql, myKey);
    }

    string build(Json parsedSql) {
        auto string mySql = "";
        if (array_key_exists("UNION ALL", parsedSql) || array_key_exists("UNION", parsedSql)) {
            foreach ($union_type : $outer_v; parsedSql) {
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
                        throw new UnableToCreateSQLException("FROM", $union_type, $outer_v, "expr_type");
                    }
                }
            }
        }
        else {
            foreach (myKey, myValue; parsedSql) {
                size_t oldSqlLength = mySql.length;
                mySql ~= this.buildTable(myValue, $k);
                mySql ~= this.buildTableExpression(myValue, $k);
                mySql ~= this.buildSubquery(myValue, $k);

                if (oldSqlLength == mySql.length) { // No change
                    throw new UnableToCreateSQLException("FROM", myKey, myValue, "expr_type");
                }
            }
        }
        return "FROM " ~ mySql;
    }
}
