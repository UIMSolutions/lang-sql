
module langs.sql.sqlparsers.processors.groupby;

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

        foreach (myToken; $tokens) {
            auto strippedToken = myToken.strip.toUpper;
            switch (strippedToken) {
            case ",":
                $parsed = this.processOrderExpression($parseInfo, $select);
                unset($parsed["direction"]);

                $out[] = $parsed;
                $parseInfo = this.initParseInfo();
                break;
            default:
                $parseInfo.baseExpression ~= myToken;
            }
        }

        $parsed = this.processOrderExpression($parseInfo, $select);
        unset($parsed["direction"]);
        $out[] = $parsed;

        return $out;
    }
}
