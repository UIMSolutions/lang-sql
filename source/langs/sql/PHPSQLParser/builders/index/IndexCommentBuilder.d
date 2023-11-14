
/**
 * IndexCommentBuilder.php
 *
 * Builds index comment part of a CREATE INDEX statement. */

module source.langs.sql.PHPSQLParser.builders.index.IndexCommentBuilder;

import lang.sql;

@safe:

/**
 * This class : the builder for the index comment of CREATE INDEX statement. 
 * You can overwrite all functions to achieve another handling.
 */
class IndexCommentBuilder : ISqlBuilder {

    protected auto buildReserved($parsed) {
        auto myBuilder = new ReservedBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilderr.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::COMMENT) {
            return "";
        }
        auto mySql = "";
        foreach ($parsed["sub_tree"] as $k => myValue) {
            auto oldSqlLength = mySql.length;
            mySql  ~= this.buildReserved(myValue);
            mySql  ~= this.buildConstant(myValue);

            if (oldSqlLength == mySql.length) {
                throw new UnableToCreateSQLException('CREATE INDEX comment subtree', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }
}
