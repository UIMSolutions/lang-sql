module langs.sql.sqlparsers.builders.from;

import lang.sql;

@safe:

/**
 * Builds the FROM statement
 * This class : the builder for the [FROM] part. You can overwrite
 * all functions to achieve another handling.
 */
class FromBuilder : ISqlBuilder {

    protected auto buildTable(parsedSQL, myKey) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSQL, myKey);
    }

    protected auto buildTableExpression(parsedSQL, myKey) {
        auto myBuilder = new TableExpressionBuilder();
        return myBuilder.build(parsedSQL, myKey);
    }

    protected auto buildSubQuery(parsedSQL, myKey) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSQL, myKey);
    }

    string build(Json parsedSQL) {
        auto string mySql = "";
        if (array_key_exists("UNION ALL", parsedSQL) || array_key_exists("UNION", parsedSQL)) {
            foreach ($union_type : $outer_v; parsedSQL) {
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
            foreach (myKey, myValue; parsedSQL) {
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
