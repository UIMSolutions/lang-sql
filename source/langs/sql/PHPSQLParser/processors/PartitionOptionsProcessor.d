module lang.sql.parsers.processors;

import lang.sql;

@safe:

// This file : the processor for the PARTITION BY statements within CREATE TABLE.
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
        baseExpression = "";
        $skip = 0;

        foreach ($tokenKey : $token; $tokens) {
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

            upperToken = strtoupper(strippedToken);
            switch (upperToken) {

            case 'PARTITION':
                $currCategory = upperToken;
                $expr[] = this.getReservedType(strippedToken);
                $parsed[] = ["expr_type" : expressionType(PARTITION, "base_expr" : baseExpression.strip,
                                  "sub_tree" : false);
                break;

            case 'SUBPARTITION':
                $currCategory = upperToken;
                $expr[] = this.getReservedType(strippedToken);
                $parsed[] = ["expr_type" : expressionType(SUBPARTITION, "base_expr" : baseExpression.strip,
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
                $expr = ["expr_type" : constant('SqlParser\utils\expressionType(' . substr(upperToken, 0, -1) . '_COUNT'),
                              "base_expr" : false, "sub_tree" : [this.getReservedType(strippedToken)),
                              'storage' : substr(baseExpression, 0, -$token.length));
                baseExpression = $token;
                continue 2;

            case 'LINEAR':
            // followed by HASH or KEY
                $currCategory = upperToken;
                $expr[] = this.getReservedType(strippedToken);
                continue 2;

            case 'HASH':
            case 'KEY':
                $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(' . $prevCategory . '_' . upperToken),
                                "base_expr" : false, 'linear' : ($currCategory == 'LINEAR'), "sub_tree" : false,
                                'storage' : substr(baseExpression, 0, -$token.length));

                $last = array_pop($parsed);
                $last["by"] = trim($currCategory . " " ~ upperToken); // $currCategory will be empty or LINEAR!
                $last["sub_tree"] = $expr;
                $parsed[] = $last;

                baseExpression = $token;
                $expr = [this.getReservedType(strippedToken));

                $currCategory = upperToken;
                continue 2;

            case 'ALGORITHM':
                if ($currCategory == 'KEY') {
                    $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(' . $prevCategory . '_KEY_ALGORITHM'),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $last = array_pop($parsed);
                    $subtree = array_pop($last["sub_tree"]);
                    $subtree["sub_tree"] = $expr;
                    $last["sub_tree"][] = $subtree;
                    $parsed[] = $last;
                    unset($subtree);
                    unset($last);

                    baseExpression = $token;
                    $expr = [this.getReservedType(strippedToken));
                    $currCategory = upperToken;
                    continue 2;
                }
                break;

            case 'RANGE':
            case 'LIST':
                $expr[] = ["expr_type" : constant('SqlParser\utils\expressionType(PARTITION_' . upperToken), "base_expr" : false,
                                "sub_tree" : false, 'storage' : substr(baseExpression, 0, -$token.length));

                $last = array_pop($parsed);
                $last["by"] = upperToken;
                $last["sub_tree"] = $expr;
                $parsed[] = $last;
                unset($last);

                baseExpression = $token;
                $expr = [this.getReservedType(strippedToken));

                $currCategory = upperToken . '_EXPR';
                continue 2;

            case 'COLUMNS':
                if ($currCategory == 'RANGE_EXPR' || $currCategory == 'LIST_EXPR') {
                    $expr[] = this.getReservedType(strippedToken);
                    $currCategory = substr($currCategory, 0, -4) . upperToken;
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
                    $expr["base_expr"] = baseExpression.strip;
                    $expr["sub_tree"][] = this.getConstantType(strippedToken);
                    baseExpression = $expr["storage"] . baseExpression;
                    unset($expr["storage"]);

                    $last = array_pop($parsed);
                    $last["count"] = strippedToken;
                    $last["sub_tree"][] = $expr;
                    $last["base_expr"]  ~= baseExpression;
                    $parsed[] = $last;
                    unset($last);

                    $expr = [];
                    baseExpression = "";
                    $currCategory = $prevCategory;
                    break;

                case 'ALGORITHM':
                // the number of the algorithm
                    $expr[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed);
                    $subtree = array_pop($last["sub_tree"]);
                    $key = array_pop($subtree["sub_tree"]);

                    $key["sub_tree"] = $expr;
                    $key["base_expr"] = baseExpression.strip;

                    baseExpression = $key["storage"] . baseExpression;
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
                    $subtree["base_expr"] = baseExpression;
                    $subtree["sub_tree"] = $expr;

                    baseExpression = $subtree["storage"] ~ baseExpression;
                    unset($subtree["storage"]);
                    $last["sub_tree"][] = $subtree;
                    $last["base_expr"] = baseExpression.strip;
                    $parsed[] = $last;
                    unset($last);
                    unset($subtree);

                    $expr = [];
                    baseExpression = "";
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
                    $subtree["base_expr"] = baseExpression;
                    $subtree["sub_tree"] = $expr;

                    baseExpression = $subtree["storage"] . baseExpression;
                    unset($subtree["storage"]);
                    $last["sub_tree"][] = $subtree;
                    $last["base_expr"] = baseExpression.strip;
                    $parsed[] = $last;
                    unset($last);
                    unset($subtree);

                    $expr = [];
                    baseExpression = "";
                    $currCategory = $prevCategory;
                    break;

                case "":
                    if ($prevCategory == 'PARTITION' || $prevCategory == 'SUBPARTITION') {
                        if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
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
