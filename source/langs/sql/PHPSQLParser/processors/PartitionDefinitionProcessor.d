
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
        return ["expr_type" : expressionType("RESERVED"), "base_expr" : $token);
    }

    protected auto getConstantType($token) {
        return ["expr_type" : expressionType(CONSTANT, "base_expr" : $token);
    }

    protected auto getOperatorType($token) {
        return ["expr_type" : expressionType(OPERATOR, "base_expr" : $token);
    }

    protected auto getBracketExpressionType($token) {
        return ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : $token, "sub_tree" : false);
    }

    auto process($tokens) {

        $result = [];
        $prevCategory = "";
        $currCategory = "";
        $parsed = [];
        $expr = [];
        baseExpression = "";
        $skip = 0;

        foreach ($tokenKey, $token; $tokens) {
            auto strippedToken = $token.strip;
            baseExpression  ~= $token;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            $upper = strippedToken.toUpper;
            switch ($upper) {

            case 'PARTITION':
                if ($currCategory.isEmpty) {
                    $expr[] = this.getReservedType(strippedToken);
                    $parsed = ["expr_type" : expressionType(PARTITION_DEF, "base_expr" : trim(baseExpression),
                                    "sub_tree" : false);
                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'VALUES':
                if ($prevCategory == 'PARTITION') {
                    $expr[] = ["expr_type" : expressionType(PARTITION_VALUES, "base_expr" : false,
                                    "sub_tree" : false, 'storage' : substr(baseExpression, 0, -$token.length));
                    $parsed["sub_tree"] = $expr;

                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'LESS':
                if ($currCategory == 'VALUES') {
                    $expr[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case 'THAN':
                if ($currCategory == 'VALUES') {
                    // followed by parenthesis and (value-list or expr)
                    $expr[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case 'MAXVALUE':
                if ($currCategory == 'VALUES') {
                    $expr[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["base_expr"] = baseExpression;
                    $last["sub_tree"] = $expr;

                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = trim(baseExpression);

                    $expr = $parsed["sub_tree"];
                    unset($last);
                    $currCategory = $prevCategory;
                }
                // else ?
                break;

            case 'IN':
                if ($currCategory == 'VALUES') {
                    // followed by parenthesis and value-list
                    $expr[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case 'COMMENT':
                if ($prevCategory == 'PARTITION') {
                    $expr[] = ["expr_type" : expressionType(PARTITION_COMMENT, "base_expr" : false,
                                    "sub_tree" : false, 'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'STORAGE':
                if ($prevCategory == 'PARTITION') {
                    // followed by ENGINE
                    $expr[] = ["expr_type" : expressionType(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'ENGINE':
                if ($currCategory == 'STORAGE') {
                    $expr[] = this.getReservedType(strippedToken);
                    $currCategory = $upper;
                    continue 2;
                }
                if ($prevCategory == 'PARTITION') {
                    $expr[] = ["expr_type" : expressionType(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case '=':
                if (in_array($currCategory, ['ENGINE', 'COMMENT', 'DIRECTORY', 'MAX_ROWS', 'MIN_ROWS'))) {
                    $expr[] = this.getOperatorType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case ',':
                if ($prevCategory == 'PARTITION' && $currCategory.isEmpty) {
                    // it separates the partition-definitions
                    $result[] = $parsed;
                    $parsed = [];
                    baseExpression = "";
                    $expr = [];
                }
                break;

            case 'DATA':
            case 'INDEX':
                if ($prevCategory == 'PARTITION') {
                    // followed by DIRECTORY
                    $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(PARTITION_' . $upper . '_DIR'),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'DIRECTORY':
                if ($currCategory == 'DATA' || $currCategory == 'INDEX') {
                    $expr[] = this.getReservedType(strippedToken);
                    $currCategory = $upper;
                    continue 2;
                }
                // else ?
                break;

            case 'MAX_ROWS':
            case 'MIN_ROWS':
                if ($prevCategory == 'PARTITION') {
                    $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(PARTITION_' . $upper),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = $expr;
                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));

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
                    $expr[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["sub_tree"] = $expr;
                    $last["base_expr"] = trim(baseExpression);
                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);

                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = trim(baseExpression);

                    $expr = $parsed["sub_tree"];
                    unset($last);

                    $currCategory = $prevCategory;
                    break;

                case 'PARTITION':
                // that is the partition name
                    $last = array_pop($expr);
                    $last["name"] = strippedToken;
                    $expr[] = $last;
                    $expr[] = this.getConstantType(strippedToken);
                    $parsed["sub_tree"] = $expr;
                    $parsed["base_expr"] = trim(baseExpression);
                    break;

                case 'VALUES':
                // we have parenthesis and have to process an expression/in-list
                    $last = this.getBracketExpressionType(strippedToken);

                    $res = this.processExpressionList(strippedToken);
                    $last["sub_tree"] = (empty($res) ? false : $res);
                    $expr[] = $last;

                    $last = array_pop($parsed["sub_tree"]);
                    $last["base_expr"] = baseExpression;
                    $last["sub_tree"] = $expr;

                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = trim(baseExpression);

                    $expr = $parsed["sub_tree"];
                    unset($last);

                    $currCategory = $prevCategory;
                    break;

                case "":
                    if ($prevCategory == 'PARTITION') {
                        // last part to process, it is only one token!
                        if ($upper[0] == "(" && substr($upper, -1) == ")") {
                            $last = this.getBracketExpressionType(strippedToken);
                            $last["sub_tree"] = this.processSubpartitionDefinition(strippedToken);
                            $expr[] = $last;
                            unset($last);

                            $parsed["base_expr"] = trim(baseExpression);
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
