module langs.sql.sqlparsers.builders.having;

import lang.sql;

@safe:

/**
 * Builds the HAVING part.
 * This class : the builder for the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 */
class HavingBuilder : WhereBuilder {

    protected auto buildAliasReference(parsedSQL) {
        auto myBuilder = new AliasReferenceBuilder();
        return myBuilder.build(parsedSQL);
    }
	
	protected auto buildHavingExpression(parsedSQL) {
        auto myBuilder = new HavingExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    protected auto buildHavingBracketExpression(parsedSQL) {
        auto myBuilder = new HavingBracketExpressionBuilder();
        return myBuilder.build(parsedSQL);
    }

    string build(Json parsedSQL) {
        string mySql = "HAVING ";
        foreach (myKey, myValue; parsedSQL) {
            size_t oldSqlLength = mySql.length;

            mySql ~= this.buildAliasReference(myValue);
            mySql ~= this.buildOperator(myValue);
            mySql ~= this.buildConstant(myValue);
            mySql ~= this.buildColRef(myValue);
            mySql ~= this.buildSubQuery(myValue);
            mySql ~= this.buildInList(myValue);
            mySql ~= this.buildFunction(myValue);
            mySql ~= this.buildHavingExpression(myValue);
            mySql ~= this.buildHavingBracketExpression(myValue);
            mySql ~= this.buildUserVariable(myValue);

            if (mySql.length == oldSqlLength) {
                throw new UnableToCreateSQLException("HAVING", myKey, myValue, "expr_type");
            }

            mySql ~= " ";
        }
        return substr(mySql, 0, -1);
    }

}
