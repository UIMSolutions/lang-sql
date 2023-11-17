
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
        myExpression = this.removeParenthesisFromStart($unparsed);
        auto myTokens = this.splitSQLIntoTokens(myExpression);
        return myProcessor.process(myTokens);
    }

    protected auto processSubpartitionDefinition($unparsed) {
        auto myProcessor = new SubpartitionDefinitionProcessor(this.options);
        myExpression = this.removeParenthesisFromStart($unparsed);
        auto myTokens = this.splitSQLIntoTokens(myExpression);
        return myProcessor.process(myTokens);
    }

    protected auto getReservedType($token) {
        return ["expr_type" : expressionType("RESERVED"), "base_expr" : $token];
    }

    protected auto getConstantType($token) {
        return ["expr_type" : expressionType("CONSTANT"), "base_expr" : $token];
    }

    protected auto getOperatorType($token) {
        return ["expr_type" : expressionType(OPERATOR, "base_expr" : $token];
    }

    protected auto getBracketExpressionType($token) {
        return ["expr_type" : expressionType(BRACKET_EXPRESSION, "base_expr" : $token, "sub_tree" : false];
    }

    auto process($tokens) {

        $result = [];
        $prevCategory = "";
        currentCategory = "";
        $parsed = [];
        myExpression = [];
        baseExpression = "";
        $skip = 0;

        foreach ($tokenKey, $token; $tokens) {
            auto strippedToken = $token.strip;
            baseExpression ~= $token;

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

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case 'PARTITION':
                if (currentCategory.isEmpty) {
                    myExpression[] = this.getReservedType(strippedToken);
                    $parsed = ["expr_type" : expressionType(PARTITION_DEF, "base_expr" : baseExpression.strip,
                                    "sub_tree" : false];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'VALUES':
                if ($prevCategory == 'PARTITION') {
                    myExpression[] = ["expr_type" : expressionType(PARTITION_VALUES, "base_expr" : false,
                                    "sub_tree" : false, 'storage' : substr(baseExpression, 0, -$token.length));
                    $parsed["sub_tree"] = myExpression;

                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'LESS':
                if (currentCategory == 'VALUES') {
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case 'THAN':
                if (currentCategory == 'VALUES') {
                    // followed by parenthesis and (value-list or expr)
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case 'MAXVALUE':
                if (currentCategory == 'VALUES') {
                    myExpression[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["base_expr"] = baseExpression;
                    $last["sub_tree"] = myExpression;

                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = baseExpression.strip;

                    myExpression = $parsed["sub_tree"];
                    unset($last);
                    currentCategory = $prevCategory;
                }
                // else ?
                break;

            case 'IN':
                if (currentCategory == 'VALUES') {
                    // followed by parenthesis and value-list
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case 'COMMENT':
                if ($prevCategory == 'PARTITION') {
                    myExpression[] = ["expr_type" : expressionType(PARTITION_COMMENT, "base_expr" : false,
                                    "sub_tree" : false, 'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'STORAGE':
                if ($prevCategory == 'PARTITION') {
                    // followed by ENGINE
                    myExpression[] = ["expr_type" : expressionType(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'ENGINE':
                if (currentCategory == 'STORAGE') {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = upperToken;
                    continue 2;
                }
                if ($prevCategory == 'PARTITION') {
                    myExpression[] = ["expr_type" : expressionType(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case '=':
                if (in_array(currentCategory, ['ENGINE', 'COMMENT', 'DIRECTORY', 'MAX_ROWS', 'MIN_ROWS'))) {
                    myExpression[] = this.getOperatorType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case ",":
                if ($prevCategory == 'PARTITION' && currentCategory.isEmpty) {
                    // it separates the partition-definitions
                    $result[] = $parsed;
                    $parsed = [];
                    baseExpression = "";
                    myExpression = [];
                }
                break;

            case 'DATA':
            case 'INDEX':
                if ($prevCategory == 'PARTITION') {
                    // followed by DIRECTORY
                    myExpression[] = ["expr_type" : constant('SqlParser\utils\expressionType(PARTITION_' . upperToken . '_DIR'),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'DIRECTORY':
                if (currentCategory == 'DATA' || currentCategory == 'INDEX') {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case 'MAX_ROWS':
            case 'MIN_ROWS':
                if ($prevCategory == 'PARTITION') {
                    myExpression[] = ["expr_type" : constant('SqlParser\utils\expressionType(PARTITION_' . upperToken),
                                    "base_expr" : false, "sub_tree" : false,
                                    'storage' : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            default:
                switch (currentCategory) {

                case 'MIN_ROWS':
                case 'MAX_ROWS':
                case 'ENGINE':
                case 'DIRECTORY':
                case 'COMMENT':
                    myExpression[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["sub_tree"] = myExpression;
                    $last["base_expr"] = baseExpression.strip;
                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);

                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = baseExpression.strip;

                    myExpression = $parsed["sub_tree"];
                    unset($last);

                    currentCategory = $prevCategory;
                    break;

                case 'PARTITION':
                // that is the partition name
                    $last = array_pop(myExpression);
                    $last["name"] = strippedToken;
                    myExpression[] = $last;
                    myExpression[] = this.getConstantType(strippedToken);
                    $parsed["sub_tree"] = myExpression;
                    $parsed["base_expr"] = baseExpression.strip;
                    break;

                case 'VALUES':
                // we have parenthesis and have to process an expression/in-list
                    $last = this.getBracketExpressionType(strippedToken);

                    $res = this.processExpressionList(strippedToken);
                    $last["sub_tree"] = (empty($res) ? false : $res);
                    myExpression[] = $last;

                    $last = array_pop($parsed["sub_tree"]);
                    $last["base_expr"] = baseExpression;
                    $last["sub_tree"] = myExpression;

                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed["base_expr"] = baseExpression.strip;

                    myExpression = $parsed["sub_tree"];
                    unset($last);

                    currentCategory = $prevCategory;
                    break;

                case "":
                    if ($prevCategory == 'PARTITION') {
                        // last part to process, it is only one token!
                        if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                            $last = this.getBracketExpressionType(strippedToken);
                            $last["sub_tree"] = this.processSubpartitionDefinition(strippedToken);
                            myExpression[] = $last;
                            unset($last);

                            $parsed["base_expr"] = baseExpression.strip;
                            $parsed["sub_tree"] = myExpression;

                            currentCategory = $prevCategory;
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

            $prevCategory = currentCategory;
            currentCategory = "";
        }

        $result[] = $parsed;
        return $result;
    }
}
