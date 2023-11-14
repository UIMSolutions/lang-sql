
/**
 * DataTypeBuilder.php
 *
 * Builds the data-type statement part of CREATE TABLE.
 * */

module source.langs.sql.PHPSQLParser.builders.datatype;

import lang.sql;

@safe:

/**
 * This class : the builder for the data-type statement part of CREATE TABLE. 
 * You can overwrite all functions to achieve another handling. */
class DataTypeBuilder : IBuilder {

    auto build(array $parsed) {
        if ($parsed["expr_type"] != ExpressionType::DATA_TYPE) {
            return "";
        }
        return $parsed["base_expr"];
    }
}