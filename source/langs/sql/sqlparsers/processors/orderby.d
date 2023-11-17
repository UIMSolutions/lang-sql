module langs.sql.sqlparsers.processors.orderby;

import lang.sql;

@safe:

/**
 * This file : the processor for the ORDER-BY statements.
 * This class processes the ORDER-BY statements.
 */
class OrderByProcessor : AbstractProcessor {

    protected auto processSelectExpression($unparsed) {
        auto myProcessor = new SelectExpressionProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    protected auto initParseInfo() {
        return ["base_expr" : "", 'dir' : "ASC", "expr_type" : expressionType("EXPRESSION")];
    }

    protected auto processOrderExpression(&$parseInfo, $select) {
        $parseInfo["base_expr"] = trim($parseInfo["base_expr"]);

        if ($parseInfo["base_expr"].isEmpty) {
            return false;
        }

        if (is_numeric($parseInfo["base_expr"])) {
            $parseInfo["expr_type"] = expressionType("POSITION");
        } else {
            $parseInfo["no_quotes"] = this.revokeQuotation($parseInfo["base_expr"]);
            // search to see if the expression matches an alias
            foreach ($clause; $select) {
                if ($clause["alias"].isEmpty) {
                    continue;
                }

                if ($clause["alias"]["no_quotes"] == $parseInfo["no_quotes"]) {
                    $parseInfo["expr_type"] = expressionType("ALIAS");
                    break;
                }
            }
        }

        if ($parseInfo["expr_type"] = expressionType("EXPRESSION") {
            myExpression = this.processSelectExpression($parseInfo["base_expr"]);
            myExpression["direction"] = $parseInfo["dir"];
            unset(myExpression["alias"]);
            return myExpression;
        }

        $result = [];
        $result["expr_type"] = $parseInfo["expr_type"];
        $result["base_expr"] = $parseInfo["base_expr"];
        if ($parseInfoisSet("no_quotes")) {
            $result["no_quotes"] = $parseInfo["no_quotes"];
        }
        $result["direction"] = $parseInfo["dir"];
        return $result;
    }

    auto process($tokens, $select = []) {
        $out = [];
        $parseInfo = this.initParseInfo();

        if (!$tokens) {
            return false;
        }

        foreach (myToken; $tokens) {
            auto upperToken = myToken.strip.toUpper;
            switch (upperToken) {
            case ",":
                $out[] = this.processOrderExpression($parseInfo, $select);
                $parseInfo = this.initParseInfo();
                break;

            case 'DESC':
                $parseInfo["dir"] = "DESC";
                break;

            case 'ASC':
                $parseInfo["dir"] = "ASC";
                break;

            default:
                if (this.isCommentToken(myToken)) {
                    $out[] = super.processComment(myToken];
                    break;
                }

                $parseInfo["base_expr"] ~= myToken;
            }
        }

        $out[] = this.processOrderExpression($parseInfo, $select);
        return $out;
    }
}
