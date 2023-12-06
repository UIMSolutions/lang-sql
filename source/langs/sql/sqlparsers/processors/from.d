module langs.sql.sqlparsers.processors.from;

import lang.sql;

@safe:

/**
 * This file : the processor for the FROM statement.
 * This class processes the FROM statement.
 * */
class FromProcessor : Processor {

    protected Json processExpressionList(myunparsed) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process(myunparsed);
    }

    protected Json processColumnList(myunparsed) {
        auto myProcessor = new ColumnListProcessor(this.options);
        return myProcessor.process(myunparsed);
    }

    protected Json processSQLDefault(myunparsed) {
        auto myProcessor = new DefaultProcessor(this.options);
        return myProcessor.process(myunparsed);
    }

    protected auto initParseInfo(Json parseInfo = Json(null)) {
        Json newParseInfo = parseInfo.isNull
            ? Json(["join_type" : "", "saved_join_type" : "JOIN"]);
            : parseInfo;

        // loop init
        Json result = createExpression("", false);
        result["token_count"] = 0;
        result["table"] = "";
        result["no_quotes"] = "";
        result["alias"] = false;
        result["hints"] = Json.emptyArray;
        result["join_type"] = "";
        result["next_join_type"] = "";
        result["saved_join_type"] = newParseInfo["saved_join_type"];
        result["ref_type"] = false;
        result["ref_expr"] = false;
        result["sub_tree"] = false;
        result["subquery"] = "";
        return result;
    }

    protected Json processFromExpression(&parseInfo) {
        result = [];

        if (parseInfo["hints"].isEmpty) {
            parseInfo["hints"] = false;
        }

        // exchange the join types (join_type is save now, saved_join_type holds the next one)
        parseInfo["join_type"] = parseInfo["saved_join_type"]; // initialized with JOIN
        parseInfo["saved_join_type"] = (parseInfo["next_join_type"] ? parseInfo["next_join_type"] : "JOIN");

        // we have a reg_expr, so we have to parse it
        if (parseInfo["ref_expr"] != false) {
            myunparsed = this.splitSQLIntoTokens(parseInfo["ref_expr"].strip);

            // here we can get a comma separated list
            myunparsed.byKeyValue
                .filter!(kv => this.isCommaToken(kv.value)) {
                .each!(kv => myunparsed[kv.key] = "");

            if (parseInfo["ref_type"] == "USING") {
            	// unparsed has only one entry, the column list
            	 myref = this.processColumnList(this.removeParenthesisFromStart(myunparsed[0]));
                 Json newExpression = createExpression("COLUMN_LIST", myunparsed[0]);
                 newExpression["sub_tree"] = myref;
            	 myref = [newExpression];
            } else {
                myref = this.processExpressionList(myunparsed);
            }
            parseInfo["ref_expr"] = (myref.isEmpty ? false : myref);
        }

        // there is an expression, we have to parse it
        if (substr(parseInfo["table"].strip, 0, 1) == "(") {
            parseInfo["expression"] = this.removeParenthesisFromStart(parseInfo["table"]);

            if (preg_match("/^\\s*(-- [\\w\\s]+\\n)?\\s*SELECT/i", parseInfo["expression"])) {
                parseInfo["sub_tree"] = this.processSQLDefault(parseInfo["expression"]);
                result["expr_type"].isExpressionType("SUBQUERY")
            } else {
                mytmp = this.splitSQLIntoTokens(parseInfo["expression"]);
                myunionProcessor = new UnionProcessor(this.options);
                myunionQueries = myunionProcessor.process(mytmp);

                // If there was no UNION or UNION ALL in the query, then the query is
                // stored at myqueries[0].
                if (!myunionQueries.isEmpty && !UnionProcessor::isUnion(myunionQueries)) {
                    mysub_tree = this.process(myunionQueries[0]);
                }
                else {
                    mysub_tree = myunionQueries;
                }
                parseInfo["sub_tree"] = mysub_tree;
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

    Json process(strig[] tokens) {
        auto parseInfo = this.initParseInfo();
        auto myExpression = [];
        string tokenCategory = "";
        string previousToken = "";

        myskip_next = false;
        myi = 0;

        foreach (myToken; mytokens) {
            upperToken = myToken.strip.toUpper;

            if (myskip_next && myToken != "") {
                parseInfo["token_count"]++;
                myskip_next = false;
                continue;
            } else {
                if (myskip_next) {
                    continue;
                }
            }

            if (this.isCommentToken(myToken)) {
               myExpression ~= super.processComment(myToken];
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
                myi++;
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
                myi++;
                continue;
            }

            switch (upperToken) {
            case "AS":
                parseInfo["alias"] = ["as" : true, "name" : "", "base_expr" : myToken];
                parseInfo["token_count"]++;
                myn = 1;
                mystr = "";
                while (mystr.isEmpty && mytokens.isSet(myi + myn)) {
                    parseInfo["alias"].baseExpression ~= (mytokens[myi + myn].isEmpty ? " " : mytokens[myi + myn]);
                    mystr = mytokens[myi + myn].strip;
                    ++ myn;
                }
                parseInfo["alias"]["name"] = mystr;
                parseInfo["alias"]["no_quotes"] = this.revokeQuotation(mystr);
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
                    mycur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][mycur_hint]["hint_type"] ~= " " ~ upperToken;
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
                    mycur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][mycur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

                parseInfo["token_count"]++;
                myskip_next = true;
                break;

            case "STRAIGHT_JOIN":
                parseInfo["next_join_type"] = "STRAIGHT_JOIN";
                if (parseInfo["subquery"]) {
                    parseInfo["sub_tree"] = this.parse(this.removeParenthesisFromStart(parseInfo["subquery"]));
                    parseInfo["expression"] = parseInfo["subquery"];
                }

               myExpression ~= this.processFromExpression(parseInfo);
                parseInfo = this.initParseInfo(parseInfo);
                break;

            case ",":
                parseInfo["next_join_type"] = "CROSS";

            case "JOIN":
                if (tokenCategory == "IDX_HINT") {
                    mycur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][mycur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

                if (parseInfo["subquery"]) {
                    parseInfo["sub_tree"] = this.parse(this.removeParenthesisFromStart(parseInfo["subquery"]));
                    parseInfo["expression"] = parseInfo["subquery"];
                }

               myExpression ~= this.processFromExpression(parseInfo);
                parseInfo = this.initParseInfo(parseInfo);
                break;

            case "GROUP BY":
                if (tokenCategory == "IDX_HINT") {
                    mycur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][mycur_hint]["hint_type"] ~= " " ~ upperToken;
                    continue 2;
                }

            default:
                // TODO: enhance it, so we can have base_expr to calculate the position of the keywords
                // build a subtree under "hints"
                if (tokenCategory == "IDX_HINT") {
                    tokenCategory = "";
                    mycur_hint = (count(parseInfo["hints"]) - 1);
                    parseInfo["hints"][mycur_hint]["hint_list"] = myToken;
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
            myi++;
        }

       myExpression ~= this.processFromExpression(parseInfo);
        return myExpression;
    }

}

