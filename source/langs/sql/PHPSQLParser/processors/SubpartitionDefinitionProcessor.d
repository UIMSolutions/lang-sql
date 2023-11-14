
/**
 * SubpartitionDefinitionProcessor.php
 *
 * This file : the processor for the SUBPARTITION statements 
 * within CREATE TABLE.
 *
 *

 *
 */

module lang.sql.parsers.processors;
use SqlParser\utils\ExpressionType;

/**
 * This class processes the SUBPARTITION statements within CREATE TABLE.
 */
class SubpartitionDefinitionProcessor : AbstractProcessor {

    protected auto getReservedType($token) {
        return array('expr_type' => ExpressionType::RESERVED, 'base_expr' => $token);
    }

    protected auto getConstantType($token) {
        return array('expr_type' => ExpressionType::CONSTANT, 'base_expr' => $token);
    }

    protected auto getOperatorType($token) {
        return array('expr_type' => ExpressionType::OPERATOR, 'base_expr' => $token);
    }

    protected auto getBracketExpressionType($token) {
        return array('expr_type' => ExpressionType::BRACKET_EXPRESSION, 'base_expr' => $token, 'sub_tree' => false);
    }

    auto process($tokens) {

        $result = array();
        $prevCategory = "";
        $currCategory = "";
        $parsed = array();
        $expr = array();
        $base_expr = "";
        $skip = 0;

        foreach ($tokens as $tokenKey => $token) {
            $trim = trim($token);
            $base_expr  ~= $token;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
                break;
            }

            if ($trim == '') {
                continue;
            }

            $upper = strtoupper($trim);
            switch ($upper) {

            case 'SUBPARTITION':
                if ($currCategory == '') {
                    $expr[] = this.getReservedType($trim);
                    $parsed = array('expr_type' => ExpressionType::SUBPARTITION_DEF, 'base_expr' => trim($base_expr),
                                    'sub_tree' => false);
                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'COMMENT':
                if ($prevCategory == 'SUBPARTITION') {
                    $expr[] = array('expr_type' => ExpressionType::SUBPARTITION_COMMENT, 'base_expr' => false,
                                    'sub_tree' => false, 'storage' => substr($base_expr, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    $base_expr = $token;
                    $expr = array(this.getReservedType($trim));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'STORAGE':
                if ($prevCategory == 'SUBPARTITION') {
                    // followed by ENGINE
                    $expr[] = array('expr_type' => ExpressionType::ENGINE, 'base_expr' => false, 'sub_tree' => false,
                                    'storage' => substr($base_expr, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    $base_expr = $token;
                    $expr = array(this.getReservedType($trim));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'ENGINE':
                if ($currCategory == 'STORAGE') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = $upper;
                    continue 2;
                }
                if ($prevCategory == 'SUBPARTITION') {
                    $expr[] = array('expr_type' => ExpressionType::ENGINE, 'base_expr' => false, 'sub_tree' => false,
                                    'storage' => substr($base_expr, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    $base_expr = $token;
                    $expr = array(this.getReservedType($trim));
                    
                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case '=':
                if (in_array($currCategory, array('ENGINE', 'COMMENT', 'DIRECTORY', 'MAX_ROWS', 'MIN_ROWS'))) {
                    $expr[] = this.getOperatorType($trim);
                    continue 2;
                }
                // else ?
                break;

            case ',':
                if ($prevCategory == 'SUBPARTITION' && $currCategory == '') {
                    // it separates the subpartition-definitions
                    $result[] = $parsed;
                    $parsed = array();
                    $base_expr = "";
                    $expr = array();
                }
                break;

            case 'DATA':
            case 'INDEX':
                if ($prevCategory == 'SUBPARTITION') {
                    // followed by DIRECTORY
                    $expr[] = array('expr_type' => constant('SqlParser\utils\ExpressionType::SUBPARTITION_' . $upper . '_DIR'),
                                    'base_expr' => false, 'sub_tree' => false,
                                    'storage' => substr($base_expr, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    $base_expr = $token;
                    $expr = array(this.getReservedType($trim));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'DIRECTORY':
                if ($currCategory == 'DATA' || $currCategory == 'INDEX') {
                    $expr[] = this.getReservedType($trim);
                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'MAX_ROWS':
            case 'MIN_ROWS':
                if ($prevCategory == 'SUBPARTITION') {
                    $expr[] = array('expr_type' => constant('SqlParser\utils\ExpressionType::SUBPARTITION_' . $upper),
                                    'base_expr' => false, 'sub_tree' => false,
                                    'storage' => substr($base_expr, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    $base_expr = $token;
                    $expr = array(this.getReservedType($trim));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            default:
                switch ($currCategory) {

                case 'MIN_ROWS':
                case 'MAX_ROWS':
                case 'ENGINE':
                case 'DIRECTORY':
                case 'COMMENT':
                    $expr[] = this.getConstantType($trim);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["sub_tree"] = $expr;
                    $last["base_expr"] = trim($base_expr);
                    $base_expr = $last["storage"] . $base_expr;
                    unset($last["storage"]);

                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = trim($base_expr);
                    $expr = $parsed["sub_tree"];
                    unset($last);

                    $currCategory = $prevCategory;
                    break;

                case 'SUBPARTITION':
                // that is the subpartition name
                    $last = array_pop($expr);
                    $last["name"] = $trim;
                    $expr[] = $last;
                    $expr[] = this.getConstantType($trim);
                    $parsed["sub_tree"] = $expr;
                    $parsed["base_expr"] = trim($base_expr);
                    break;

                default:
                    break;
                }
                break;
            }

            $prevCategory = $currCategory;
            $currCategory = "";
        }

        $result[] = $parsed;
        return $result;
    }
}
