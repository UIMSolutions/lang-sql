
/**
 * ConstraintBuilder.php
 *
 * Builds the constraint statement part of CREATE TABLE.
 *
 *

module lang.sql.parsers.builders;
use SqlParser\utils\ExpressionType;

/**
 * This class : the builder for the constraint statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling.
class ConstraintBuilder : ISqlBuilder {

    protected auto buildConstant($parsed) {
        $builder = new ConstantBuilder();
        return $builder.build($parsed);
    }

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CONSTRAINT) {
            return '';
        }
        $sql = $parsed["sub_tree"] == false ? '' : this.buildConstant($parsed["sub_tree"]);
        return "CONSTRAINT" . (empty($sql) ? '' : (' ' . $sql));
    }

}
