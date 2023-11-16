
/**
 * PartitionOptionsProcessor.php
 *
 * This file : the processor for the PARTITION BY statements
 * within CREATE TABLE.
 */

module lang.sql.parsers.processors;

import lang.sql;

@safe:

// This class processes the PARTITION BY statements within CREATE TABLE.
class PartitionOptionsProcessor : AbstractProcessor {

    protected auto processExpressionList($unparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        $expr = this.removeParenthesisFromStart($unparsed);
        $expr = this.splitSQLIntoTokens($expr);
        return myProcessor.process($expr);
    }

    protected auto processColumnList($unparsed) {
        auto myProcessor = new ColumnListProcessor(this.options);
        $expr = this.removeParenthesisFromStart($unparsed);
        return myProcessor.process($expr);
    }

    protected auto processPartitionDefinition($unparsed) {
        auto myProcessor = new PartitionDefinitionProcessor(this.options);
        $expr = this.removeParenthesisFromStart($unparsed);
        $expr = this.splitSQLIntoTokens($expr);
        return myProcessor.process($expr);
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

        $result = ['partition-options' : [], 'last-parsed' : false);

        $prevCategory = "";
        $currCategory = "";
        $parsed = [];
        $expr = [];
        $base_expr = "";
        $skip = 0;

        foreach ($tokenKey : $token; $tokens) {
            auto strippedToken = $token.strip;
            $base_expr  ~= $token;

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

            $upper = strtoupper(strippedToken);
            switch ($upper) {

            case 'PARTITION':
                $currCategory = $upper;
                $expr[] = this.getReservedType(strippedToken);
                $parsed[] = ["expr_type" : expressionType(PARTITION, "base_expr" : trim($base_expr),
                                  "sub_tree" : false);
                break;

            case 'SUBPARTITION':
                $currCategory = $upper;
                $expr[] = this.getReservedType(strippedToken);
                $parsed[] = ["expr_type" : expressionType(SUBPARTITION, "base_expr" : trim($base_expr),
                                  "sub_tree" : false);
                break;

            case 'BY':
                if ($prevCategory == 'PARTITION' || $prevCategory == 'SUBPARTITION') {
                    $expr[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case 'PARTITIONS':
            case 'SUBPARTITIONS':
                $currCategory = 'PARTITION_NUM';
                $expr = ["expr_type" : constant('SqlParser\utils\expressionType(' . substr($upper, 0, -1) . '_COUNT'),
                              "base_expr" : false, "sub_tree" : [this.getReservedType(strippedToken)),
                              'storage' : substr($base_expr, 0, -$token.length));
                $base_expr = $token;
                continue 2;

            case 'LINEAR':
            // followed by HASH or KEY
                $currCategory = $upper;
                $expr[] = this.getReservedType(strippedToken);
                continue 2;

            case 'HASH':
            case 'KEY':
                $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(' . $prevCategory . '_' . $upper),
                                "base_expr" : false, 'linear' : ($currCategory == 'LINEAR'), "sub_tree" : false,
                                'storage' : substr($base_expr, 0, -$token.length));

                $last = array_pop($parsed);
                $last["by"] = trim($currCategory . " " ~ $upper); // $currCategory will be empty or LINEAR!
                $last["sub_tree"] = $expr;
                $parsed[] = $last;

                $base_expr = $token;
                $expr = [this.getReservedType(strippedToken));

                $currCategory = $upper;
                continue 2;

            case 'ALGORITHM':
                if ($currCategory == 'KEY') {
                    $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(' . $prevCategory . '_KEY_ALGORITHM'),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr($base_expr, 0, -$token.length));

                    $last = array_pop($parsed);
                    $subtree = array_pop($last["sub_tree"]);
                    $subtree["sub_tree"] = $expr;
                    $last["sub_tree"][] = $subtree;
                    $parsed[] = $last;
                    unset($subtree);
                    unset($last);

                    $base_expr = $token;
                    $expr = [this.getReservedType(strippedToken));
                    $currCategory = $upper;
                    continue 2;
                }
                break;

            case 'RANGE':
            case 'LIST':
                $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(PARTITION_' . $upper), "base_expr" : false,
                                "sub_tree" : false, 'storage' : substr($base_expr, 0, -$token.length));

                $last = array_pop($parsed);
                $last["by"] = $upper;
                $last["sub_tree"] = $expr;
                $parsed[] = $last;
                unset($last);

                $base_expr = $token;
                $expr = [this.getReservedType(strippedToken));

                $currCategory = $upper . '_EXPR';
                continue 2;

            case 'COLUMNS':
                if ($currCategory == 'RANGE_EXPR' || $currCategory == 'LIST_EXPR') {
                    $expr[] = this.getReservedType(strippedToken);
                    $currCategory = substr($currCategory, 0, -4) . $upper;
                    continue 2;
                }
                break;

            case '=':
                if ($currCategory == 'ALGORITHM') {
                    // between ALGORITHM and a constant
                    $expr[] = this.getOperatorType(strippedToken);
                    continue 2;
                }
                break;

            default:
                switch ($currCategory) {

                case 'PARTITION_NUM':
                // the number behind PARTITIONS or SUBPARTITIONS
                    $expr["base_expr"] = trim($base_expr);
                    $expr["sub_tree"][] = this.getConstantType(strippedToken);
                    $base_expr = $expr["storage"] . $base_expr;
                    unset($expr["storage"]);

                    $last = array_pop($parsed);
                    $last["count"] = strippedToken;
                    $last["sub_tree"][] = $expr;
                    $last["base_expr"]  ~= $base_expr;
                    $parsed[] = $last;
                    unset($last);

                    $expr = [];
                    $base_expr = "";
                    $currCategory = $prevCategory;
                    break;

                case 'ALGORITHM':
                // the number of the algorithm
                    $expr[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed);
                    $subtree = array_pop($last["sub_tree"]);
                    $key = array_pop($subtree["sub_tree"]);

                    $key["sub_tree"] = $expr;
                    $key["base_expr"] = trim($base_expr);

                    $base_expr = $key["storage"] . $base_expr;
                    unset($key["storage"]);

                    $subtree["sub_tree"][] = $key;
                    unset($key);

                    $expr = $subtree["sub_tree"];
                    $subtree["sub_tree"] = false;
                    $subtree["algorithm"] = strippedToken;
                    $last["sub_tree"][] = $subtree;
                    unset($subtree);

                    $parsed[] = $last;
                    unset($last);
                    $currCategory = 'KEY';
                    continue 3;

                case 'LIST_EXPR':
                case 'RANGE_EXPR':
                case 'HASH':
                // parenthesis around an expression
                    $last = this.getBracketExpressionType(strippedToken);
                    $res = this.processExpressionList(strippedToken);
                    $last["sub_tree"] = (empty($res) ? false : $res);
                    $expr[] = $last;

                    $last = array_pop($parsed);
                    $subtree = array_pop($last["sub_tree"]);
                    $subtree["base_expr"] = $base_expr;
                    $subtree["sub_tree"] = $expr;

                    $base_expr = $subtree["storage"] ~ $base_expr;
                    unset($subtree["storage"]);
                    $last["sub_tree"][] = $subtree;
                    $last["base_expr"] = trim($base_expr);
                    $parsed[] = $last;
                    unset($last);
                    unset($subtree);

                    $expr = [];
                    $base_expr = "";
                    $currCategory = $prevCategory;
                    break;

                case 'LIST_COLUMNS':
                case 'RANGE_COLUMNS':
                case 'KEY':
                // the columnlist
                    $expr[] = ["expr_type" : expressionType(COLUMN_LIST, "base_expr" : strippedToken,
                                    "sub_tree" : this.processColumnList(strippedToken));

                    $last = array_pop($parsed);
                    $subtree = array_pop($last["sub_tree"]);
                    $subtree["base_expr"] = $base_expr;
                    $subtree["sub_tree"] = $expr;

                    $base_expr = $subtree["storage"] . $base_expr;
                    unset($subtree["storage"]);
                    $last["sub_tree"][] = $subtree;
                    $last["base_expr"] = trim($base_expr);
                    $parsed[] = $last;
                    unset($last);
                    unset($subtree);

                    $expr = [];
                    $base_expr = "";
                    $currCategory = $prevCategory;
                    break;

                case "":
                    if ($prevCategory == 'PARTITION' || $prevCategory == 'SUBPARTITION') {
                        if ($upper[0] == "(" && substr($upper, -1) == ")") {
                            // last part to process, it is only one token!
                            $last = this.getBracketExpressionType(strippedToken);
                            $last["sub_tree"] = this.processPartitionDefinition(strippedToken);
                            $parsed[] = $last;
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

        $result["partition-options"] = $parsed;
        if ($result["last-parsed"] == false) {
            $result["last-parsed"] = $tokenKey;
        }
        return $result;
    }
}
