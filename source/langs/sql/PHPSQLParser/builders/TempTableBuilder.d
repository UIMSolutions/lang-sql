
/**
 * TempTableBuilder.php
 *
 * Builds the temporary table name/join options.
 * 
 */

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the temporary table name and join options. 
 * You can overwrite all functions to achieve another handling.
 *
 
 
 *  
 */
class TempTableBuilder : ISqlBuilder {

    protected auto buildAlias($parsed) {
        $builder = new AliasBuilder();
        return $builder.build($parsed);
    }

    protected auto buildJoin($parsed) {
        $builder = new JoinBuilder();
        return $builder.build($parsed);
    }

    protected auto buildRefType($parsed) {
        $builder = new RefTypeBuilder();
        return $builder.build($parsed);
    }

    protected auto buildRefClause($parsed) {
        $builder = new RefClauseBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed, $index = 0) {
        if ($parsed["expr_type"] != ExpressionType::TEMPORARY_TABLE) {
            return "";
        }

        $sql = $parsed["table"];
        $sql  ~= this.buildAlias($parsed);

        if ($index != 0) {
            $sql = this.buildJoin($parsed["join_type"]) . $sql;
            $sql  ~= this.buildRefType($parsed["ref_type"]);
            $sql  ~= $parsed["ref_clause"] == false ? '' : this.buildRefClause($parsed["ref_clause"]);
        }
        return $sql;
    }
}
