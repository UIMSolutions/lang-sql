
/**
 * CreateProcessor.php
 *
 * This file : the processor for the CREATE statements.
 */

module source.langs.sql.PHPSQLParser.processors.create;

import lang.sql;

@safe:

/**
 * This class processes the CREATE statements.
 */
class CreateProcessor : AbstractProcessor {

    auto process($tokens) {
        $result = $expr = array();
        $base_expr = "";

        foreach ($tokens as $token) {
            
            $trim = trim($token);
            $base_expr  ~= $token;

            if ($trim == "") {
                continue;
            }

            $upper = strtoupper($trim);
            switch ($upper) {

            case 'TEMPORARY':
                // CREATE TEMPORARY TABLE
                $result["expr_type"] = ExpressionType::TEMPORARY_TABLE;
                $result["not-exists"] = false;
                $expr[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                break;

            case 'TABLE':
                // CREATE TABLE
                $result["expr_type"] = ExpressionType::TABLE;
                $result["not-exists"] = false;
                $expr[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                break;

            case 'INDEX':
                // CREATE INDEX
                $result["expr_type"] = ExpressionType::INDEX;
                $expr[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                break;

            case 'UNIQUE':
            case 'FULLTEXT':
            case 'SPATIAL':
                // options of CREATE INDEX
                $result["base_expr"] = $result["expr_type"] = false;
                $result["constraint"] = $upper; 
                $expr[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                break;                
                                
            case 'IF':
                // option of CREATE TABLE
                $expr[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                break;

            case 'NOT':
                // option of CREATE TABLE
                $expr[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
                break;

            case 'EXISTS':
                // option of CREATE TABLE
                $result["not-exists"] = true;
                $expr[] = array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $trim);
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