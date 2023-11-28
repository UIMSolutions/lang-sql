module langs.sql.sqlparsers.builders.from;

import lang.sql;

@safe:

/**
 * Builds the FROM statement
 */
class FromBuilder : ISqlBuilder {

    string build(Json parsedSql) {
        auto string mySql = "";
        if (array_key_exists("UNION ALL", parsedSql) || array_key_exists("UNION", parsedSql)) {
            foreach ($union_type : resulter_v; parsedSql) {
                $first = true;

                foreach ($item; resulter_v) {
                    if (!$first) {
                        mySql ~= " $union_type ";
                    } else {
                        $first = false;
                    }

                    $select_builder = new SelectStatementBuilder();

                    size_t oldSqlLength = mySql.length;
                    mySql ~= $select_builder.build($item);

                    if (oldSqlLength == mySql.length) { // No change
                        throw new UnableToCreateSQLException("FROM", $union_type, resulter_v, "expr_type");
                    }
                }
            }
        } else {
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
    protected string buildTable(parsedSql, myKey) {
        auto myBuilder = new TableBuilder();
        return myBuilder.build(parsedSql, myKey);
    }

    protected string buildTableExpression(parsedSql, myKey) {
        auto myBuilder = new TableExpressionBuilder();
        return myBuilder.build(parsedSql, myKey);
    }

    protected string buildSubQuery(parsedSql, myKey) {
        auto myBuilder = new SubQueryBuilder();
        return myBuilder.build(parsedSql, myKey);
    }

}
