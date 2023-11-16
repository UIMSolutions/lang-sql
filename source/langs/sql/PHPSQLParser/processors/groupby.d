
module langs.sql.PHPSQLParser.processors.groupby;

/**
 * This file : the processor for the GROUP-BY statements.
 * This class processes the GROUP-BY statements.
 */
class GroupByProcessor : OrderByProcessor {

    auto process($tokens, $select = []) {
        $out = [];
        $parseInfo = this.initParseInfo();

        if (!$tokens) {
            return false;
        }

        foreach ($token; $tokens) {
            auto strippedToken = $token.strip.toUpper;
            switch (strippedToken) {
            case ",":
                $parsed = this.processOrderExpression($parseInfo, $select);
                unset($parsed["direction"]);

                $out[] = $parsed;
                $parseInfo = this.initParseInfo();
                break;
            default:
                $parseInfo["base_expr"] ~= $token;
            }
        }

        $parsed = this.processOrderExpression($parseInfo, $select);
        unset($parsed["direction"]);
        $out[] = $parsed;

        return $out;
    }
}
