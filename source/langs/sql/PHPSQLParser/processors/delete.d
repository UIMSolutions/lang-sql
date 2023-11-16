module langs.sql.PHPSQLParser.processors.delete;

/**
 * Processes the DELETE statement parts and splits multi-table deletes.
 * This class processes the DELETE statements.
 * You can overwrite all functions to achieve another handling.
 */
class DeleteProcessor : AbstractProcessor {

    auto process($tokens) {
        $tables = [];
        $del = $tokens["DELETE"];

        foreach (myExpression; $tokens["DELETE"]) {
            if (myExpression.toUpper != 'DELETE' && (myExpression, " \t\n\r\0\x0B.*").strip != ""
                && !this.isCommaToken(myExpression)) {
                $tables[] = trim(myExpression, " \t\n\r\0\x0B.*");
            }
        }

        if (empty($tables) && "USING" in $tokens)) {
            foreach ($table; $tokens["FROM"] ) {
                $tables[] = ($table["table"], " \t\n\r\0\x0B.*").strip;
            }
            $tokens["FROM"] = $tokens["USING"];
            unset($tokens["USING"]);
        }

        $options = [];
        if ($tokens.isSet("OPTIONS")) {
            $options = $tokens["OPTIONS"];
            $tokens.remove("OPTIONS");
        }

        $tokens["DELETE"] = ['options' : (empty($options) ? false : $options),
                                  'tables' : (empty($tables) ? false : $tables)];
        return $tokens;
    }
}
