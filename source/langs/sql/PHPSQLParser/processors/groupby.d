
/**
 * GroupByProcessor.php
 *
 * This file : the processor for the GROUP-BY statements.
 */

module source.langs.sql.PHPSQLParser.processors.groupby;

/**
 * 
 * This class processes the GROUP-BY statements.
 */
class GroupByProcessor : OrderByProcessor {

    auto process($tokens, $select = array()) {
        $out = array();
        $parseInfo = this.initParseInfo();

        if (!$tokens) {
            return false;
        }

        foreach ($tokens as $token) {
            $trim = strtoupper(trim($token));
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
