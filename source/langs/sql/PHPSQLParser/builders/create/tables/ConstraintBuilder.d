/**
 * ConstraintBuilder.php
 *
 * Builds the constraint statement part of CREATE TABLE.
*/

module source.langs.sql.PHPSQLParser.builders.create.tables.ConstraintBuilder;

import lang.sql;

@safe:

/**
 * This class : the builder for the constraint statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class ConstraintBuilder : ISqlBuilder {

    protected auto buildConstant($parsed) {
        auto myBuilder = new ConstantBuilder();
        return myBuilder.build($parsed);
    }

    string build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::CONSTRAINT) {
            return "";
        }
        $sql = $parsed["sub_tree"] == false ? '' : this.buildConstant($parsed["sub_tree"]);
        return "CONSTRAINT" . (empty($sql) ? '' : (" " ~ $sql));
    }

}

