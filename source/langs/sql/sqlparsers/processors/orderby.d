module langs.sql.sqlparsers.processors.orderby;

import lang.sql;

@safe:

// This class processes the ORDER-BY statements.
class OrderByProcessor : AbstractProcessor {

    protected auto processSelectExpression($unparsed) {
        auto myProcessor = new SelectExpressionProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    protected auto initParseInfo() {
        Json result = createExpression("EXPRESSION", "");
        result["dir"] = "ASC";
        return result;
    }

    protected auto processOrderExpression( & Json parseInfo, $select) {
        parseInfo["base_expr"] = parseInfo.baseExpression.strip;

        if (parseInfo.baseExpression.isEmpty) {
            return false;
        }

        if (parseInfo.baseExpression.isNumeric) {
            parseInfo["expr_type"] = expressionType("POSITION");
        } else {
            parseInfo["no_quotes"] = this.revokeQuotation(parseInfo.baseExpression);
            // search to see if the expression matches an alias
            foreach (myClause; $select) {
                if (myClause["alias"].isEmpty) {
                    continue;
                }

                if (myClause["alias"]["no_quotes"] == parseInfo["no_quotes"]) {
                    parseInfo["expr_type"] = expressionType("ALIAS");
                    break;
                }
            }
        }

        if (parseInfo.isExpressionType("EXPRESSION")) {
            myExpression = this.processSelectExpression(parseInfo.baseExpression);
            myExpression["direction"] = parseInfo["dir"];
            unset(myExpression["alias"]);
            return myExpression;
        }

        Json result = Json.emptyObject;
        result["expr_type"] = parseInfo["expr_type"];
        result["base_expr"] = parseInfo.baseExpression;
        if (parseInfo.isSet("no_quotes")) {
            result["no_quotes"] = parseInfo["no_quotes"];
        }
        result["direction"] = parseInfo["dir"];
        return result;
    }

    auto process($tokens, $select = []) {
        result  = [];
        parseInfo = this.initParseInfo();

        if (!$tokens) {
            return false;
        }

        foreach (myToken; $tokens) {
            auto upperToken = myToken.strip.toUpper;
            switch (upperToken) {
            case "," : result [] = this.processOrderExpression(parseInfo, $select);
                parseInfo = this.initParseInfo();
                break;

            case "DESC" : parseInfo["dir"] = "DESC";
                break;

            case "ASC" : parseInfo["dir"] = "ASC";
                break;

            default : if (this.isCommentToken(myToken)) {
                    result [] = super.processComment(myToken]; break;}

                    parseInfo.baseExpression ~= myToken;}
                }

                result [] = this.processOrderExpression(parseInfo, $select); return result ;
            }
        }
