module lang.sql.parsers.processors;

import lang.sql;

@safe:

// This class processes the PARTITION statements within CREATE TABLE.
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
        return createExpression("RESERVED"), "base_expr" : $token];
    }

    protected auto getConstantType($token) {
        return createExpression("CONSTANT"), "base_expr" : $token];
    }

    protected auto getOperatorType($token) {
        return createExpression("OPERATOR"), "base_expr" : $token];
    }

    protected auto getBracketExpressionType($token) {
        return createExpression("BRACKET_EXPRESSION"), "base_expr" : $token, "sub_tree" : false];
    }

    auto process($tokens) {

        $result = [];
        string myPreviousCategory = "";
        string myCurrentCategory = "";
        $parsed = [];
        myExpression = [];
        string baseExpression = "";
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

            case "PARTITION":
                if (myCurrentCategory.isEmpty) {
                    myExpression[] = this.getReservedType(strippedToken);
                    $parsed = createExpression("PARTITION_DEF"), "base_expr" : baseExpression.strip,
                                    "sub_tree" : false];
                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "VALUES":
                if (myPreviousCategory == "PARTITION") {
                    myExpression[] = createExpression("PARTITION_VALUES"), "base_expr" : false,
                                    "sub_tree" : false, "storage" : substr(baseExpression, 0, -$token.length));
                    $parsed["sub_tree"] = myExpression;

                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "LESS":
                if (myCurrentCategory == "VALUES") {
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case "THAN":
                if (myCurrentCategory == "VALUES") {
                    // followed by parenthesis and (value-list or expr)
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case "MAXVALUE":
                if (myCurrentCategory == "VALUES") {
                    myExpression[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last.baseExpression = baseExpression;
                    $last["sub_tree"] = myExpression;

                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed.baseExpression = baseExpression.strip;

                    myExpression = $parsed["sub_tree"];
                    unset($last);
                    myCurrentCategory = myPreviousCategory;
                }
                // else ?
                break;

            case "IN":
                if (myCurrentCategory == "VALUES") {
                    // followed by parenthesis and value-list
                    myExpression[] = this.getReservedType(strippedToken);
                    continue 2;
                }
                break;

            case "COMMENT":
                if (myPreviousCategory == "PARTITION") {
                    myExpression[] = createExpression(PARTITION_COMMENT, "base_expr" : false,
                                    "sub_tree" : false, "storage" : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "STORAGE":
                if (myPreviousCategory == "PARTITION") {
                    // followed by ENGINE
                    myExpression[] = createExpression("ENGINE"), "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "ENGINE":
                if (myCurrentCategory == "STORAGE") {
                    myExpression[] = this.getReservedType(strippedToken);
                    myCurrentCategory = upperToken;
                    continue 2;
                }
                if (myPreviousCategory == "PARTITION") {
                    myExpression[] = createExpression(ENGINE, "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "=":
                if (in_array(myCurrentCategory, ["ENGINE", "COMMENT", "DIRECTORY", "MAX_ROWS", "MIN_ROWS"))) {
                    myExpression[] = this.getOperatorType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case ",":
                if (myPreviousCategory == "PARTITION" && myCurrentCategory.isEmpty) {
                    // it separates the partition-definitions
                    $result[] = $parsed;
                    $parsed = [];
                    baseExpression = "";
                    myExpression = [];
                }
                break;

            case "DATA":
            case "INDEX":
                if (myPreviousCategory == "PARTITION") {
                    // followed by DIRECTORY
                    myExpression[] = ["expr_type" : constant("SqlParser\utils\expressionType(PARTITION_" . upperToken . "_DIR"),
                                    "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "DIRECTORY":
                if (myCurrentCategory == "DATA" || myCurrentCategory == "INDEX") {
                    myExpression[] = this.getReservedType(strippedToken);
                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "MAX_ROWS":
            case "MIN_ROWS":
                if (myPreviousCategory == "PARTITION") {
                    myExpression[] = ["expr_type" : constant("SqlParser\utils\expressionType(PARTITION_" . upperToken),
                                    "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -$token.length));

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = $token;
                    myExpression = [this.getReservedType(strippedToken));

                    myCurrentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            default:
                switch (myCurrentCategory) {

                case "MIN_ROWS":
                case "MAX_ROWS":
                case "ENGINE":
                case "DIRECTORY":
                case "COMMENT":
                    myExpression[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["sub_tree"] = myExpression;
                    $last.baseExpression = baseExpression.strip;
                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);

                    $parsed["sub_tree"][] = $last;
                    $parsed.baseExpression = baseExpression.strip;

                    myExpression = $parsed["sub_tree"];
                    unset($last);

                    myCurrentCategory = myPreviousCategory;
                    break;

                case "PARTITION":
                // that is the partition name
                    $last = array_pop(myExpression);
                    $last["name"] = strippedToken;
                    myExpression[] = $last;
                    myExpression[] = this.getConstantType(strippedToken);
                    $parsed["sub_tree"] = myExpression;
                    $parsed.baseExpression = baseExpression.strip;
                    break;

                case "VALUES":
                // we have parenthesis and have to process an expression/in-list
                    $last = this.getBracketExpressionType(strippedToken);

                    $res = this.processExpressionList(strippedToken);
                    $last["sub_tree"] = (empty($res) ? false : $res);
                    myExpression[] = $last;

                    $last = array_pop($parsed["sub_tree"]);
                    $last.baseExpression = baseExpression;
                    $last["sub_tree"] = myExpression;

                    baseExpression = $last["storage"] . baseExpression;
                    unset($last["storage"]);
                    $parsed["sub_tree"][] = $last;
                    $parsed.baseExpression = baseExpression.strip;

                    myExpression = $parsed["sub_tree"];
                    unset($last);

                    myCurrentCategory = myPreviousCategory;
                    break;

                case "":
                    if (myPreviousCategory == "PARTITION") {
                        // last part to process, it is only one token!
                        if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                            $last = this.getBracketExpressionType(strippedToken);
                            $last["sub_tree"] = this.processSubpartitionDefinition(strippedToken);
                            myExpression[] = $last;
                            unset($last);

                            $parsed.baseExpression = baseExpression.strip;
                            $parsed["sub_tree"] = myExpression;

                            myCurrentCategory = myPreviousCategory;
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

            myPreviousCategory = myCurrentCategory;
            myCurrentCategory = "";
        }

        $result[] = $parsed;
        return $result;
    }
}
