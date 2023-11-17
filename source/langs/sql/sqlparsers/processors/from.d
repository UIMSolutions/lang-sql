module langs.sql.PHPSQLParser.processors.from;

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

    protected auto initParseInfo($parseInfo = false) {
        // first init
        if ($parseInfo == false) {
            $parseInfo = ['join_type' : "", 'saved_join_type' : "JOIN");
        }
        // loop init
        return ['expression' : "", 'token_count' : 0, 'table' : "", "no_quotes" : "", 'alias' : false,
                     'hints' : [], 'join_type' : "", 'next_join_type' : "",
                     'saved_join_type' : $parseInfo["saved_join_type"], 'ref_type' : false, 'ref_expr' : false,
                     "base_expr" : false, "sub_tree" : false, 'subquery' : "");
    }

    protected auto processFromExpression(&$parseInfo) {
        $res = [];

        if ($parseInfo["hints"] == []) {
            $parseInfo["hints"] = false;
        }

        // exchange the join types (join_type is save now, saved_join_type holds the next one)
        $parseInfo["join_type"] = $parseInfo["saved_join_type"]; // initialized with JOIN
        $parseInfo["saved_join_type"] = ($parseInfo["next_join_type"] ? $parseInfo["next_join_type"] : 'JOIN');

        // we have a reg_expr, so we have to parse it
        if ($parseInfo["ref_expr"] != false) {
            $unparsed = this.splitSQLIntoTokens(trim($parseInfo["ref_expr"]));

            // here we can get a comma separated list
            foreach (myKey, myValue; $unparsed) {
                if (this.isCommaToken(myValue)) {
                    $unparsed[$k] = "";
                }
            }
            if ($parseInfo["ref_type"] == 'USING') {
            	// unparsed has only one entry, the column list
            	$ref = this.processColumnList(this.removeParenthesisFromStart($unparsed[0]));
            	$ref = [["expr_type" : expressionType(COLUMN_LIST, "base_expr" : $unparsed[0], "sub_tree" : $ref));
            } else {
                $ref = this.processExpressionList($unparsed);
            }
            $parseInfo["ref_expr"] = (empty($ref) ? false : $ref);
        }

        // there is an expression, we have to parse it
        if (substr(trim($parseInfo["table"]), 0, 1) == "(") {
            $parseInfo["expression"] = this.removeParenthesisFromStart($parseInfo["table"]);

            if (preg_match("/^\\s*(-- [\\w\\s]+\\n)?\\s*SELECT/i", $parseInfo["expression"])) {
                $parseInfo["sub_tree"] = this.processSQLDefault($parseInfo["expression"]);
                $res["expr_type"] .isExpressionType(SUBQUERY;
            } else {
                $tmp = this.splitSQLIntoTokens($parseInfo["expression"]);
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
                $parseInfo["sub_tree"] = $sub_tree;
                $res["expr_type"} = expressionType("TABLE_EXPRESSION");
            }
        } else {
            $res["expr_type"] = expressionType("TABLE");
            $res["table"] = $parseInfo["table"];
            $res["no_quotes"] = this.revokeQuotation($parseInfo["table"]);
        }

        $res["alias"] = $parseInfo["alias"];
        $res["hints"] = $parseInfo["hints"];
        $res["join_type"] = $parseInfo["join_type"];
        $res["ref_type"] = $parseInfo["ref_type"];
        $res["ref_clause"] = $parseInfo["ref_expr"];
        $res["base_expr"] = trim($parseInfo["expression"]);
        $res["sub_tree"] = $parseInfo["sub_tree"];
        return $res;
    }

    auto process($tokens) {
        $parseInfo = this.initParseInfo();
        myExpression = [];
        $token_category = "";
        $prevToken = "";

        $skip_next = false;
        $i = 0;

        foreach ($token; $tokens) {
            upperToken = $token.strip.toUpper;

            if ($skip_next && $token != "") {
                $parseInfo["token_count"]++;
                $skip_next = false;
                continue;
            } else {
                if ($skip_next) {
                    continue;
                }
            }

            if (this.isCommentToken($token)) {
                myExpression[] = super.processComment($token];
                continue;
            }

            switch (upperToken) {
            case 'CROSS':
            case ",":
            case 'INNER':
            case 'STRAIGHT_JOIN':
                break;

            case 'OUTER':
            case 'JOIN':
                if ($token_category == 'LEFT' || $token_category == 'RIGHT' || $token_category == 'NATURAL') {
                    $token_category = "";
                    $parseInfo["next_join_type"] = trim($prevToken)); // it seems to be a join
                } elseif ($token_category == 'IDX_HINT') {
                    $parseInfo["expression"] ~= $token;
                    if ($parseInfo["ref_type"] != false) { // all after ON / USING
                        $parseInfo["ref_expr"] ~= $token;
                    }
                }
                break;

            case 'LEFT':
            case 'RIGHT':
            case 'NATURAL':
                $token_category = upperToken;
                $prevToken = $token;
                $i++;
                continue 2;

            default:
                if ($token_category == 'LEFT' || $token_category == 'RIGHT') {
                    if (upperToken.isEmpty) {
                        $prevToken ~= $token;
                        break;
                    } else {
                        $token_category = "";     // it seems to be a function
                        $parseInfo["expression"] ~= $prevToken;
                        if ($parseInfo["ref_type"] != false) { // all after ON / USING
                            $parseInfo["ref_expr"] ~= $prevToken;
                        }
                        $prevToken = "";
                    }
                }
                $parseInfo["expression"] ~= $token;
                if ($parseInfo["ref_type"] != false) { // all after ON / USING
                    $parseInfo["ref_expr"] ~= $token;
                }
                break;
            }

            if (upperToken.isEmpty) {
                $i++;
                continue;
            }

            switch (upperToken) {
            case 'AS':
                $parseInfo["alias"] = ['as' : true, 'name' : "", "base_expr" : $token];
                $parseInfo["token_count"]++;
                $n = 1;
                $str = "";
                while ($str.isEmpty && isset($tokens[$i + $n])) {
                    $parseInfo["alias"]["base_expr"] ~= ($tokens[$i + $n].isEmpty ? " " : $tokens[$i + $n]);
                    $str = trim($tokens[$i + $n]);
                    ++$n;
                }
                $parseInfo["alias"]["name"] = $str;
                $parseInfo["alias"]["no_quotes"] = this.revokeQuotation($str);
                $parseInfo["alias"]["base_expr"] = trim($parseInfo["alias"]["base_expr"]);
                break;

            case 'IGNORE':
            case 'USE':
            case 'FORCE':
                $token_category = 'IDX_HINT';
                $parseInfo["hints"][]["hint_type"] = upperToken;
                continue 2;

            case 'KEY':
            case 'INDEX':
                if ($token_category == 'CREATE') {
                    $token_category = upperToken; // TODO: what is it for a statement?
                    continue 2;
                }
                if ($token_category == 'IDX_HINT') {
                    $cur_hint = (count($parseInfo["hints"]) - 1);
                    $parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }
                break;

            case 'USING':
            case 'ON':
                $parseInfo["ref_type"] = upperToken;
                $parseInfo["ref_expr"] = "";

            case 'CROSS':
            case 'INNER':
            case 'OUTER':
            case 'NATURAL':
                $parseInfo["token_count"]++;
                break;

            case 'FOR':
                if ($token_category == 'IDX_HINT') {
                    $cur_hint = (count($parseInfo["hints"]) - 1);
                    $parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

                $parseInfo["token_count"]++;
                $skip_next = true;
                break;

            case 'STRAIGHT_JOIN':
                $parseInfo["next_join_type"] = "STRAIGHT_JOIN";
                if ($parseInfo["subquery"]) {
                    $parseInfo["sub_tree"] = this.parse(this.removeParenthesisFromStart($parseInfo["subquery"]));
                    $parseInfo["expression"] = $parseInfo["subquery"];
                }

                myExpression[] = this.processFromExpression($parseInfo);
                $parseInfo = this.initParseInfo($parseInfo);
                break;

            case ",":
                $parseInfo["next_join_type"] = 'CROSS';

            case 'JOIN':
                if ($token_category == 'IDX_HINT') {
                    $cur_hint = (count($parseInfo["hints"]) - 1);
                    $parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

                if ($parseInfo["subquery"]) {
                    $parseInfo["sub_tree"] = this.parse(this.removeParenthesisFromStart($parseInfo["subquery"]));
                    $parseInfo["expression"] = $parseInfo["subquery"];
                }

                myExpression[] = this.processFromExpression($parseInfo);
                $parseInfo = this.initParseInfo($parseInfo);
                break;

            case 'GROUP BY':
                if ($token_category == 'IDX_HINT') {
                    $cur_hint = (count($parseInfo["hints"]) - 1);
                    $parseInfo["hints"][$cur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

            default:
                // TODO: enhance it, so we can have base_expr to calculate the position of the keywords
                // build a subtree under "hints"
                if ($token_category == 'IDX_HINT') {
                    $token_category = "";
                    $cur_hint = (count($parseInfo["hints"]) - 1);
                    $parseInfo["hints"][$cur_hint]["hint_list"] = $token;
                    break;
                }

                if ($parseInfo["token_count"] == 0) {
                    if ($parseInfo["table"].isEmpty) {
                        $parseInfo["table"] = $token;
                        $parseInfo["no_quotes"] = this.revokeQuotation($token];
                    }
                } else if ($parseInfo["token_count"] == 1) {
                    $parseInfo["alias"] = ['as' : false, 'name' : $token.strip,
                                                "no_quotes" : this.revokeQuotation($token),
                                                "base_expr" : $token.strip);
                }
                $parseInfo["token_count"]++;
                break;
            }
            $i++;
        }

        myExpression[] = this.processFromExpression($parseInfo);
        return myExpression;
    }

}
