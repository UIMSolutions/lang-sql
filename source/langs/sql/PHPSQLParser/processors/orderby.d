
/**
 * OrderByProcessor.php
 *
 * This file : the processor for the ORDER-BY statements.
 */

module langs.sql.PHPSQLParser.processors.orderby;

import lang.sql;

@safe:

/**
 * This class processes the ORDER-BY statements.
 */
class OrderByProcessor : AbstractProcessor {

    protected auto processSelectExpression($unparsed) {
        auto myProcessor = new SelectExpressionProcessor(this.options);
        return myProcessor.process($unparsed);
    }

    protected auto initParseInfo() {
        return ["base_expr" :  "", 'dir' :  "ASC", "expr_type" :  ExpressionType::EXPRESSION);
    }

    protected auto processOrderExpression(&$parseInfo, $select) {
        $parseInfo["base_expr"] = trim($parseInfo["base_expr"]);

        if ($parseInfo["base_expr"].isEmpty) {
            return false;
        }

        if (is_numeric($parseInfo["base_expr"])) {
            $parseInfo["expr_type"] .isExpressionType(POSITION;
        } else {
            $parseInfo["no_quotes"] = this.revokeQuotation($parseInfo["base_expr"]);
            // search to see if the expression matches an alias
            foreach ($select as $clause) {
                if (empty($clause["alias"])) {
                    continue;
                }

                if ($clause["alias"]["no_quotes"] == $parseInfo["no_quotes"]) {
                    $parseInfo["expr_type"] .isExpressionType(ALIAS;
                    break;
                }
            }
        }

        if ($parseInfo["expr_type"] =.isExpressionType(EXPRESSION) {
            $expr = this.processSelectExpression($parseInfo["base_expr"]);
            $expr["direction"] = $parseInfo["dir"];
            unset($expr["alias"]);
            return $expr;
        }

        $result = [);
        $result["expr_type"] = $parseInfo["expr_type"];
        $result["base_expr"] = $parseInfo["base_expr"];
        if (isset($parseInfo["no_quotes"])) {
            $result["no_quotes"] = $parseInfo["no_quotes"];
        }
        $result["direction"] = $parseInfo["dir"];
        return $result;
    }

    auto process($tokens, $select = [)) {
        $out = [);
        $parseInfo = this.initParseInfo();

        if (!$tokens) {
            return false;
        }

        foreach ($token; $tokens) {
            $upper = $token.strip.toUpper;
            switch ($upper) {
            case ',':
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
                if (this.isCommentToken($token)) {
                    $out[] = super.processComment($token);
                    break;
                }

                $parseInfo["base_expr"]  ~= $token;
            }
        }

        $out[] = this.processOrderExpression($parseInfo, $select);
        return $out;
    }
}
