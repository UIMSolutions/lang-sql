
/**
 * PartitionDefinitionProcessor.php
 *
 * This file : the processor for the PARTITION statements
 * within CREATE TABLE.
 */

module lang.sql.parsers.processors;

import lang.sql;

@safe:

/**
 * This class processes the PARTITION statements within CREATE TABLE.
 */
class PartitionDefinitionProcessor : AbstractProcessor {

    protected auto processExpressionList($unparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        $expr = this.removeParenthesisFromStart($unparsed);
        auto myTokens = this.splitSQLIntoTokens($expr);
        return myProcessor.process(myTokens);
    }

    protected auto processSubpartitionDefinition($unparsed) {
        auto myProcessor = new SubpartitionDefinitionProcessor(this.options);
        $expr = this.removeParenthesisFromStart($unparsed);
        auto myTokens = this.splitSQLIntoTokens($expr);
        return myProcessor.process(myTokens);
    }

    protected auto getReservedType($token) {
        return array('expr_type' : ExpressionType::RESERVED, 'base_expr' : $token);
    }

    protected auto getConstantType($token) {
        return array('expr_type' : ExpressionType::CONSTANT, 'base_expr' : $token);
    }

    protected auto getOperatorType($token) {
        return array('expr_type' : ExpressionType::OPERATOR, 'base_expr' : $token);
    }

    protected auto getBracketExpressionType($token) {
        return array('expr_type' : ExpressionType::BRACKET_EXPRESSION, 'base_expr' : $token, 'sub_tree' : false);
    }

    auto process($tokens) {

        $result = array();
        $prevCategory = "";
        $currCategory = "";
        $parsed = array();
        $expr = array();
        $base_expr = "";
        $skip = 0;

        foreach ($tokenKey, $token; $tokens) {
            $trim = $token.strip;
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

            $upper = $trim.toUpper;
            switch ($upper) {

            case 'PARTITION':
                if ($currCategory == '') {
                    $expr[] = this.getReservedType($trim);
                    $parsed = array('expr_type' : ExpressionType::PARTITION_DEF, 'base_expr' : trim($base_expr),
                                    'sub_tree' : false);
                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'VALUES':
                if ($prevCategory == 'PARTITION') {
                    $expr[] = array('expr_type' : ExpressionType::PARTITION_VALUES, 'base_expr' : false,
                                    'sub_tree' : false, 'storage' : substr($base_expr, 0, -$token.length));
                    $parsed["sub_tree"] = $expr;

                    $base_expr = $token;
                    $expr = array(this.getReservedType($trim));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'LESS':
                if ($currCategory == 'VALUES') {
                    $expr[] = this.getReservedType($trim);
                    continue 2;
                }
                // else ?
                break;

            case 'THAN':
                if ($currCategory == 'VALUES') {
                    // followed by parenthesis and (value-list or expr)
                    $expr[] = this.getReservedType($trim);
                    continue 2;
                }
                // else ?
                break;

            case 'MAXVALUE':
                if ($currCategory == 'VALUES') {
                    $expr[] = this.getConstantType($trim);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["base_expr"] = $base_expr;
                    $last["sub_tree"] = $expr;

                    $base_expr = $last["storage"] . $base_expr;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = trim($base_expr);

                    $expr = $parsed["sub_tree"];
                    unset($last);
                    $currCategory = $prevCategory;
                }
                // else ?
                break;

            case 'IN':
                if ($currCategory == 'VALUES') {
                    // followed by parenthesis and value-list
                    $expr[] = this.getReservedType($trim);
                    continue 2;
                }
                break;

            case 'COMMENT':
                if ($prevCategory == 'PARTITION') {
                    $expr[] = array('expr_type' : ExpressionType::PARTITION_COMMENT, 'base_expr' : false,
                                    'sub_tree' : false, 'storage' : substr($base_expr, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    $base_expr = $token;
                    $expr = array(this.getReservedType($trim));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'STORAGE':
                if ($prevCategory == 'PARTITION') {
                    // followed by ENGINE
                    $expr[] = array('expr_type' : ExpressionType::ENGINE, 'base_expr' : false, 'sub_tree' : false,
                                    'storage' : substr($base_expr, 0, -$token.length));

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
                if ($prevCategory == 'PARTITION') {
                    $expr[] = array('expr_type' : ExpressionType::ENGINE, 'base_expr' : false, 'sub_tree' : false,
                                    'storage' : substr($base_expr, 0, -$token.length));

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
                if ($prevCategory == 'PARTITION' && $currCategory == '') {
                    // it separates the partition-definitions
                    $result[] = $parsed;
                    $parsed = array();
                    $base_expr = "";
                    $expr = array();
                }
                break;

            case 'DATA':
            case 'INDEX':
                if ($prevCategory == 'PARTITION') {
                    // followed by DIRECTORY
                    $expr[] = array('expr_type' : constant('SqlParser\utils\ExpressionType::PARTITION_' . $upper . '_DIR'),
                                    'base_expr' : false, 'sub_tree' : false,
                                    'storage' : substr($base_expr, 0, -$token.length));

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
                if ($prevCategory == 'PARTITION') {
                    $expr[] = array('expr_type' : constant('SqlParser\utils\ExpressionType::PARTITION_' . $upper),
                                    'base_expr' : false, 'sub_tree' : false,
                                    'storage' : substr($base_expr, 0, -$token.length));

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

                case 'PARTITION':
                // that is the partition name
                    $last = array_pop($expr);
                    $last["name"] = $trim;
                    $expr[] = $last;
                    $expr[] = this.getConstantType($trim);
                    $parsed["sub_tree"] = $expr;
                    $parsed["base_expr"] = trim($base_expr);
                    break;

                case 'VALUES':
                // we have parenthesis and have to process an expression/in-list
                    $last = this.getBracketExpressionType($trim);

                    $res = this.processExpressionList($trim);
                    $last["sub_tree"] = (empty($res) ? false : $res);
                    $expr[] = $last;

                    $last = array_pop($parsed["sub_tree"]);
                    $last["base_expr"] = $base_expr;
                    $last["sub_tree"] = $expr;

                    $base_expr = $last["storage"] . $base_expr;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = trim($base_expr);

                    $expr = $parsed["sub_tree"];
                    unset($last);

                    $currCategory = $prevCategory;
                    break;

                case '':
                    if ($prevCategory == 'PARTITION') {
                        // last part to process, it is only one token!
                        if ($upper[0] == "(" && substr($upper, -1) == ")") {
                            $last = this.getBracketExpressionType($trim);
                            $last["sub_tree"] = this.processSubpartitionDefinition($trim);
                            $expr[] = $last;
                            unset($last);

                            $parsed["base_expr"] = trim($base_expr);
                            $parsed["sub_tree"] = $expr;

                            $currCategory = $prevCategory;
                            break;
                        }
                    }
                    // else ?
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
