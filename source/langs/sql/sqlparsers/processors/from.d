module langs.sql.sqlparsers.processors.from;

import lang.sql;

@safe:

/**
 * This file : the processor for the FROM statement.
 * This class processes the FROM statement.
 * */
class FromProcessor : AbstractProcessor {

    protected auto processExpressionList($unparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    protected auto processColumnList($unparsed) {
        auto myProcessor = new ColumnListProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    protected auto processSQLDefault($unparsed) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    protected auto initParseInfo(parseInfo = false) {
        // first init
        if (parseInfo == false) {
            parseInfo = ["join_type" : "", "saved_join_type" : "JOIN");
        }
        // loop init
        return ["expression" : "", "token_count" : 0, "table" : "", "no_quotes" : "", "alias" : false,
                     "hints" : [], "join_type" : "", "next_join_type" : "",
                     "saved_join_type" : parseInfo["saved_join_type"], "ref_type" : false, "ref_expr" : false,
                     "base_expr" : false, "sub_tree" : false, "subquery" : "");
    }

    protected auto processFromExpression(&parseInfo) {
        result = [];

        if (parseInfo["hints"] == []) {
            parseInfo["hints"] = false;
        }

        // exchange the join types (join_type is save now, saved_join_type holds the next one)
        parseInfo["join_type"] = parseInfo["saved_join_type"]; // initialized with JOIN
        parseInfo["saved_join_type"] = (parseInfo["next_join_type"] ? parseInfo["next_join_type"] : "JOIN");

        // we have a reg_expr, so we have to parse it
        if (parseInfo["ref_expr"] != false) {
            $unparsed = this.splitSQLIntoTokens(parseInfo["ref_expr"].strip);

            // here we can get a comma separated list
            foreach (myKey, myValue; $unparsed) {
                if (this.isCommaToken(myValue)) {
                    $unparsed[$k] = "";
                }
            }
            if (parseInfo["ref_type"] == "USING") {
            	// unparsed has only one entry, the column list
            	$ref = this.processColumnList(this.removeParenthesisFromStart($unparsed[0]));
            	$ref = [createExpression("COLUMN_LIST"), "base_expr" : $unparsed[0], "sub_tree" : $ref]];
            } else {
                $ref = this.processExpressionList($unparsed);
            }
            parseInfo["ref_expr"] = (empty($ref) ? false : $ref);
        }

        // there is an expression, we have to parse it
        if (substr(parseInfo["table"].strip, 0, 1) == "(") {
            parseInfo["expression"] = this.removeParenthesisFromStart(parseInfo["table"]);

            if (preg_match("/^\\s*(-- [\\w\\s]+\\n)?\\s*SELECT/i", parseInfo["expression"])) {
                parseInfo["sub_tree"] = this.processSQLDefault(parseInfo["expression"]);
                result["expr_type"] .isExpressionType(SUBQUERY;
            } else {
                $tmp = this.splitSQLIntoTokens(parseInfo["expression"]);
                $unionProcessor = new UnionProcessor(this.options);
                $unionQueries = $unionProcessor.process($tmp);

                // If there was no UNION or UNION ALL in the query, then the query is
                // stored at $queries[0].
                if (!empty($unionQueries) && !UnionProcessor::isUnion($unionQueries)) {
                    $sub_tree = this.process($unionQueries[0]);
                }
                else {
                    $sub_tree = $unionQueries;
                }
                parseInfo["sub_tree"] = $sub_tree;
                result["expr_type"] = expressionType("TABLE_EXPRESSION");
            }
        } else {
            result["expr_type"] = expressionType("TABLE");
            result["table"] = parseInfo["table"];
            result["no_quotes"] = this.revokeQuotation(parseInfo["table"]);
        }

        result["alias"] = parseInfo["alias"];
        result["hints"] = parseInfo["hints"];
        result["join_type"] = parseInfo["join_type"];
        result["ref_type"] = parseInfo["ref_type"];
        result["ref_clause"] = parseInfo["ref_expr"];
        result["base_expr"] = parseInfo["expression"].strip;
        result["sub_tree"] = parseInfo["sub_tree"];
        return result;
    }

    auto process($tokens) {
        auto parseInfo = this.initParseInfo();
        auto myExpression = [];
        string tokenCategory = "";
        string previousToken = "";

        $skip_next = false;
        $i = 0;

        foreach (myToken; $tokens) {
            upperToken = myToken.strip.toUpper;

            if ($skip_next && myToken != "") {
                parseInfo["token_count"]++;
                $skip_next = false;
                continue;
            } else {
                if ($skip_next) {
                    continue;
                }
            }

            if (this.isCommentToken(myToken)) {
                myExpression[] = super.processComment(myToken];
                continue;
            }

            switch (upperToken) {
            case "CROSS":
            case ",":
            case "INNER":
            case "STRAIGHT_JOIN":
                break;

            case "OUTER":
            case "JOIN":
                if (tokenCategory == "LEFT" || tokenCategory == "RIGHT" || tokenCategory == "NATURAL") {
                    tokenCategory = "";
                    parseInfo["next_join_type"] = previousToken.strip); // it seems to be a join
                } else if (tokenCategory == "IDX_HINT") {
                    parseInfo["expression"] ~= myToken;
                    if (parseInfo["ref_type"] != false) { // all after ON / USING
                        parseInfo["ref_expr"] ~= myToken;
                    }
                }
                break;

            case "LEFT":
            case "RIGHT":
            case "NATURAL":
                tokenCategory = upperToken;
                previousToken = myToken;
                $i++;
                continue 2;

            default:
                if (tokenCategory == "LEFT" || tokenCategory == "RIGHT") {
                    if (upperToken.isEmpty) {
                        previousToken ~= myToken;
                        break;
                    } else {
                        tokenCategory = "";     // it seems to be a function
                        parseInfo["expression"] ~= previousToken;
                        if (parseInfo["ref_type"] != false) { // all after ON / USING
                            parseInfo["ref_expr"] ~= previousToken;
                        }
                        previousToken = "";
                    }
                }
                parseInfo["expression"] ~= myToken;
                if (parseInfo["ref_type"] != false) { // all after ON / USING
                    parseInfo["ref_expr"] ~= myToken;
                }
                break;
            }

            if (upperToken.isEmpty) {
                $i++;
                continue;
            }

            switch (upperToken) {
            case "AS":
                parseInfo["alias"] = ["as" : true, "name" : "", "base_expr" : myToken];
                parseInfo["token_count"]++;
                $n = 1;
                $str = "";
                while ($str.isEmpty && $tokens.isSet($i + $n)) {
                    parseInfo["alias"].baseExpression ~= ($tokens[$i + $n].isEmpty ? " " : $tokens[$i + $n]);
                    $str = $tokens[$i + $n].strip;
                    ++$n;
                }
                parseInfo["alias"]["name"] = $str;
                parseInfo["alias"]["no_quotes"] = this.revokeQuotation($str);
                parseInfo["alias"]["base_expr"] = parseInfo["alias"].baseExpression.strip;
                break;

            case "IGNORE":
            case "USE":
            case "FORCE":
                tokenCategory = "IDX_HINT";
                parseInfo["hints"][]["hint_type"] = upperToken;
                continue 2;

            case "KEY":
            case "INDEX":
                if (tokenCategory == "CREATE") {
                    tokenCategory = upperToken; // TODO: what is it for a statement?
                    continue 2;
                }
                if (tokenCategory == "IDX_HINT") {
                    $cur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }
                break;

            case "USING":
            case "ON":
                parseInfo["ref_type"] = upperToken;
                parseInfo["ref_expr"] = "";

            case "CROSS":
            case "INNER":
            case "OUTER":
            case "NATURAL":
                parseInfo["token_count"]++;
                break;

            case "FOR":
                if (tokenCategory == "IDX_HINT") {
                    $cur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

                parseInfo["token_count"]++;
                $skip_next = true;
                break;

            case "STRAIGHT_JOIN":
                parseInfo["next_join_type"] = "STRAIGHT_JOIN";
                if (parseInfo["subquery"]) {
                    parseInfo["sub_tree"] = this.parse(this.removeParenthesisFromStart(parseInfo["subquery"]));
                    parseInfo["expression"] = parseInfo["subquery"];
                }

                myExpression[] = this.processFromExpression(parseInfo);
                parseInfo = this.initParseInfo(parseInfo);
                break;

            case ",":
                parseInfo["next_join_type"] = "CROSS";

            case "JOIN":
                if (tokenCategory == "IDX_HINT") {
                    $cur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

                if (parseInfo["subquery"]) {
                    parseInfo["sub_tree"] = this.parse(this.removeParenthesisFromStart(parseInfo["subquery"]));
                    parseInfo["expression"] = parseInfo["subquery"];
                }

                myExpression[] = this.processFromExpression(parseInfo);
                parseInfo = this.initParseInfo(parseInfo);
                break;

            case "GROUP BY":
                if (tokenCategory == "IDX_HINT") {
                    $cur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

            default:
                // TODO: enhance it, so we can have base_expr to calculate the position of the keywords
                // build a subtree under "hints"
                if (tokenCategory == "IDX_HINT") {
                    tokenCategory = "";
                    $cur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][$cur_hint]["hint_list"] = myToken;
                    break;
                }

                if (parseInfo["token_count"] == 0) {
                    if (parseInfo["table"].isEmpty) {
                        parseInfo["table"] = myToken;
                        parseInfo["no_quotes"] = this.revokeQuotation(myToken];
                    }
                } else if (parseInfo["token_count"] == 1) {
                    parseInfo["alias"] = ["as" : false, "name" : myToken.strip,
                                                "no_quotes" : this.revokeQuotation(myToken),
                                                "base_expr" : myToken.strip);
                }
                parseInfo["token_count"]++;
                break;
            }
            $i++;
        }

        myExpression[] = this.processFromExpression(parseInfo);
        return myExpression;
    }

}

