
/**
 * CreateProcessor.php
 *
 * This file : the processor for the CREATE statements.
 */

module langs.sql.PHPSQLParser.processors.create;

import lang.sql;

@safe:

/**
 * This class processes the CREATE statements.
 */
class CreateProcessor : AbstractProcessor {

    auto process($tokens) {
        $result = $expr = [];
        $base_expr = "";

        foreach (myToken; $tokens) {
            
            $trim = myToken.strip;
            $base_expr  ~= myToken;

            if ($trim.isEmpty) {
                continue;
            }

            $upper = $trim.toUpper;
            switch ($upper) {

            case 'TEMPORARY':
                // CREATE TEMPORARY TABLE
                $result["expr_type"] .isExpressionType(TEMPORARY_TABLE;
                $result["not-exists"] = false;
                $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim);
                break;

            case 'TABLE':
                // CREATE TABLE
                $result["expr_type"] =  expressionType("TABLE");
                $result["not-exists"] = false;
                $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim);
                break;

            case 'INDEX':
                // CREATE INDEX
                $result["expr_type"] .isExpressionType(INDEX;
                $expr[] = ["expr_type" : expressionType("RESERVED", "base_expr" : $trim);
                break;

            case 'UNIQUE':
            case 'FULLTEXT':
            case 'SPATIAL':
                // options of CREATE INDEX
                $result["base_expr"] = $result["expr_type"] = false;
                $result["constraint"] = $upper; 
                $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim);
                break;                
                                
            case 'IF':
                // option of CREATE TABLE
                $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim);
                break;

            case 'NOT':
                // option of CREATE TABLE
                $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim);
                break;

            case 'EXISTS':
                // option of CREATE TABLE
                $result["not-exists"] = true;
                $expr[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $trim);
                break;

            default:
                break;
            }
        }
        $result["base_expr"] = trim($base_expr);
        $result["sub_tree"] = $expr;
        return $result;
    }
}