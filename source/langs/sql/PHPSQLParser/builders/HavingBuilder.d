
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
        return $builder.build($parsed);
    }
	
	protected auto buildHavingExpression($parsed) {
        auto myBuilder = new HavingExpressionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildHavingBracketExpression($parsed) {
        auto myBuilder = new HavingBracketExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "HAVING ";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);

            $sql  ~= this.buildAliasReference($v);
            $sql  ~= this.buildOperator($v);
            $sql  ~= this.buildConstant($v);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildSubQuery($v);
            $sql  ~= this.buildInList($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildHavingExpression($v);
            $sql  ~= this.buildHavingBracketExpression($v);
            $sql  ~= this.buildUserVariable($v);

            if (strlen($sql) == $len) {
                throw new UnableToCreateSQLException('HAVING', $k, $v, 'expr_type');
            }

            $sql  ~= " ";
        }
        return substr($sql, 0, -1);
    }

}
