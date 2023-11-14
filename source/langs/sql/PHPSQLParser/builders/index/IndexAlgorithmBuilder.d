
/**
 * IndexAlgorithmBuilder.php
 *
 * Builds index algorithm part of a CREATE INDEX statement.

 */

module source.langs.sql.PHPSQLParser.builders.index.IndexAlgorithmBuilder;

import lang.sql;

@safe:

/**
 * This class : the builder for the index algorithm of CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling.
 */
class IndexAlgorithmBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }
    
    protected auto buildOperator($parsed) {
        auto myBuilder = new OperatorBuilder();
        return myBuilderr.build($parsed);
    }
    
    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::INDEX_ALGORITHM) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => $v) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildOperator($v);

            if (oldSqlLength == mySql.length) {
                throw new UnableToCreateSQLException('CREATE INDEX algorithm subtree', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
