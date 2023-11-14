
/**
 * FromBuilder.php
 *
 * Builds the FROM statement
 *
 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the [FROM] part. You can overwrite
 * all functions to achieve another handling.

 */
class FromBuilder : ISqlBuilder {

    protected auto buildTable($parsed, $key) {
        myBuilder = new TableBuilder();
        return $builder.build($parsed, $key);
    }

    protected auto buildTableExpression($parsed, $key) {
        myBuilder = new TableExpressionBuilder();
        return $builder.build($parsed, $key);
    }

    protected auto buildSubQuery($parsed, $key) {
        myBuilder = new SubQueryBuilder();
        return $builder.build($parsed, $key);
    }

    auto build(array $parsed) {
        mySql = "";
        if (array_key_exists("UNION ALL", $parsed) || array_key_exists("UNION", $parsed)) {
            foreach ($parsed as $union_type => $outer_v) {
                $first = true;

                foreach ($outer_v as $item) {
                    if (!$first) {
                        mySql  ~= " $union_type ";
                    }
                    else {
                        $first = false;
                    }

                    $select_builder = new SelectStatementBuilder();

                    $len = strlen(mySql);
                    mySql  ~= $select_builder.build($item);

                    if ($len == strlen(mySql)) {
                        throw new UnableToCreateSQLException('FROM', $union_type, $outer_v, 'expr_type');
                    }
                }
            }
        }
        else {
            foreach ($parsed as $k => $v) {
                $len = strlen(mySql);
                mySql  ~= this.buildTable($v, $k);
                mySql  ~= this.buildTableExpression($v, $k);
                mySql  ~= this.buildSubquery($v, $k);

                if ($len == strlen(mySql)) {
                    throw new UnableToCreateSQLException('FROM', $k, $v, 'expr_type');
                }
            }
        }
        return "FROM " . mySql;
    }
}
