module lang.sql.parsers.builders;

import lang.sql;

@safe:
/**
 * Builds expressions within the ORDER-BY part. */
* This class : the builder for expressions within the ORDER - BY part.
    * It must contain the direction.
    *  *  /
    class OrderByExpressionBuilder : WhereExpressionBuilder {

        protected auto buildDirection(parsedSql) {
            auto auto myBuilder = new DirectionBuilder();
            return myBuilder.build(parsedSql);
        }

        string build(Json parsedSql) {
            string mySql = super.build(parsedSql);
            if (!mySql.isEmpty) {
                mySql ~= this.buildDirection(parsedSql);
            }
            return mySql;
        }

    }
