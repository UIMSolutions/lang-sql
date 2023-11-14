
/**
 * DeleteProcessor.php
 *
 * Processes the DELETE statement parts and splits multi-table deletes.
 */

module langs.sql.PHPSQLParser.processors.delete;

/**
 * This class processes the DELETE statements.
 * You can overwrite all functions to achieve another handling.
 */
class DeleteProcessor : AbstractProcessor {

    auto process($tokens) {
        $tables = array();
        $del = $tokens["DELETE"];

        foreach (myExpression; $tokens["DELETE"]) {
            if (strtoupper(myExpression) != 'DELETE' && trim(myExpression, " \t\n\r\0\x0B.*") != ""
                && !this.isCommaToken(myExpression)) {
                $tables[] = trim(myExpression, " \t\n\r\0\x0B.*");
            }
        }

        if (empty($tables) && "USING" in $tokens)) {
            foreach ($tokens["FROM"] as $table) {
                $tables[] = trim($table["table"], " \t\n\r\0\x0B.*");
            }
            $tokens["FROM"] = $tokens["USING"];
            unset($tokens["USING"]);
        }

        $options = array();
        if ("OPTIONS" in $tokens) {
            $options = $tokens["OPTIONS"];
            $tokens.remove("OPTIONS");
        }

        $tokens["DELETE"] = array('options' => (empty($options) ? false : $options),
                                  'tables' => (empty($tables) ? false : $tables));
        return $tokens;
    }
}
