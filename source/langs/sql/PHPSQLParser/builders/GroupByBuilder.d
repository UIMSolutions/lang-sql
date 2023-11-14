
/**
 * GroupByBuilder.php
 *
 * Builds the GROUP-BY clause.

 */

module lang.sql.parsers.builders;

import lang.sql;

@safe:

/**
 * This class : the builder for the GROUP-BY clause. 
 * You can overwrite all functions to achieve another handling.
 * 
 */
class GroupByBuilder : ISqlBuilder {

    protected auto buildColRef($parsed) {
        $builder = new ColumnReferenceBuilder();
        return $builder.build($parsed);
    }

    protected auto buildPosition($parsed) {
        $builder = new PositionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildFunction($parsed) {
        $builder = new FunctionBuilder();
        return $builder.build($parsed);
    }

    protected auto buildGroupByAlias($parsed) {
        $builder = new GroupByAliasBuilder();
        return $builder.build($parsed);
    }
    
    protected auto buildGroupByExpression($parsed) {
    	$builder = new GroupByExpressionBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        $sql = "";
        foreach ($parsed as $k => $v) {
            $len = strlen($sql);
            $sql  ~= this.buildColRef($v);
            $sql  ~= this.buildPosition($v);
            $sql  ~= this.buildFunction($v);
            $sql  ~= this.buildGroupByExpression($v);
            $sql  ~= this.buildGroupByAlias($v);
            
            if ($len == strlen($sql)) {
                throw new UnableToCreateSQLException('GROUP', $k, $v, 'expr_type');
            }

            $sql  ~= ", ";
        }
        $sql = substr($sql, 0, -2);
        return "GROUP BY " . $sql;
    }

}
