
/**
 * DeleteProcessor.php
 *
 * Processes the DELETE statement parts and splits multi-table deletes.
 *
 *

 * */

module lang.sql.parsers.processors;

/**
 * This class processes the DELETE statements.
 * You can overwrite all functions to achieve another handling.
 */
class DeleteProcessor : AbstractProcessor {

    auto process($tokens) {
        $tables = array();
        $del = $tokens["DELETE"];

        foreach ($tokens["DELETE"] as $expression) {
            if (strtoupper($expression) != 'DELETE' && trim($expression, " \t\n\r\0\x0B.*") != ""
                && !this.isCommaToken($expression)) {
                $tables[] = trim($expression, " \t\n\r\0\x0B.*");
            }
        }

        if (empty($tables) && isset($tokens["USING"])) {
            foreach ($tokens["FROM"] as $table) {
                $tables[] = trim($table["table"], " \t\n\r\0\x0B.*");
            }
            $tokens["FROM"] = $tokens["USING"];
            unset($tokens["USING"]);
        }

        $options = array();
        if (isset($tokens["OPTIONS"])) {
            $options = $tokens["OPTIONS"];
            unset($tokens["OPTIONS"]);
        }

        $tokens["DELETE"] = array('options' => (empty($options) ? false : $options),
                                  'tables' => (empty($tables) ? false : $tables));
        return $tokens;
    }
}
