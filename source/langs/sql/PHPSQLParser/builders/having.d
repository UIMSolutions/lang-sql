module source.langs.sql.PHPSQLParser.builders.having;

import lang.sql;

@safe:

/**
 * Builds the HAVING part.
 * This class : the builder for the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 */
class HavingBuilder : WhereBuilder {

    protected auto buildAliasReference($parsed) {
        auto myBuilder = new AliasReferenceBuilder();
        return myBuilder.build($parsed);
    }
	
	protected auto buildHavingExpression($parsed) {
        auto myBuilder = new HavingExpressionBuilder();
        return myBuilder.build($parsed);
    }

    protected auto buildHavingBracketExpression($parsed) {
        auto myBuilder = new HavingBracketExpressionBuilder();
        return myBuilderrr.build($parsed);
    }

    string build(array $parsed) {
        auto mySql = "HAVING ";
        foreach (myKey, myValue; $parsed) {
            auto oldSqlLength = mySql.length;

            mySql  ~= this.buildAliasReference(myValue);
            mySql  ~= this.buildOperator(myValue);
            mySql  ~= this.buildConstant(myValue);
            mySql  ~= this.buildColRef(myValue);
            mySql  ~= this.buildSubQuery(myValue);
            mySql  ~= this.buildInList(myValue);
            mySql  ~= this.buildFunction(myValue);
            mySql  ~= this.buildHavingExpression(myValue);
            mySql  ~= this.buildHavingBracketExpression(myValue);
            mySql  ~= this.buildUserVariable(myValue);

            if (mySql.length == oldSqlLength) {
                throw new UnableToCreateSQLException('HAVING', $k, myValue, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }

}
