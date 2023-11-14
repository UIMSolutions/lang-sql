
/**
 * HavingBuilder.php
 *
 * Builds the HAVING part.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the HAVING part. 
 * You can overwrite all functions to achieve another handling.
 *
 * @author  Ian Barker <ian@theorganicagency.com>
 
 
 *  
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

    auto build(array $parsed) {
        auto mySql = "HAVING ";
        foreach ($parsed as $k => $v) {
            $len = strlen(mySql);

            mySql  ~= this.buildAliasReference($v);
            mySql  ~= this.buildOperator($v);
            mySql  ~= this.buildConstant($v);
            mySql  ~= this.buildColRef($v);
            mySql  ~= this.buildSubQuery($v);
            mySql  ~= this.buildInList($v);
            mySql  ~= this.buildFunction($v);
            mySql  ~= this.buildHavingExpression($v);
            mySql  ~= this.buildHavingBracketExpression($v);
            mySql  ~= this.buildUserVariable($v);

            if (strlen(mySql) == $len) {
                throw new UnableToCreateSQLException('HAVING', $k, $v, 'expr_type');
            }

            mySql  ~= " ";
        }
        return substr(mySql, 0, -1);
    }

}
