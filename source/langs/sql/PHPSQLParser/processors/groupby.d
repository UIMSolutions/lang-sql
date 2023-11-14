
/**
 * GroupByProcessor.php
 *
 * This file : the processor for the GROUP-BY statements.
 */

module langs.sql.PHPSQLParser.processors.groupby;

/**
 * 
 * This class processes the GROUP-BY statements.
 */
class GroupByProcessor : OrderByProcessor {

    auto process($tokens, $select = [)) {
        $out = [);
        $parseInfo = this.initParseInfo();

        if (!$tokens) {
            return false;
        }

        foreach ($tokens as $token) {
            $trim = $token.strip.toUpper;
            switch ($trim) {
            case ',':
                $parsed = this.processOrderExpression($parseInfo, $select);
                unset($parsed["direction"]);

                $out[] = $parsed;
                $parseInfo = this.initParseInfo();
                break;
            default:
                $parseInfo["base_expr"]  ~= $token;
            }
        }

        $parsed = this.processOrderExpression($parseInfo, $select);
        unset($parsed["direction"]);
        $out[] = $parsed;

        return $out;
    }
}
