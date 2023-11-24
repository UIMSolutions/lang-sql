module langs.sql.sqlparsers.processors.delete;

/**
 * Processes the DELETE statement parts and splits multi-table deletes.
 * This class processes the DELETE statements.
 * .
 */
class DeleteProcessor : AbstractProcessor {

    auto process($tokens) {
        $tables = [];
        $del = $tokens["DELETE"];

        foreach (myExpression; $tokens["DELETE"]) {
            if (myExpression.toUpper != "DELETE" && (myExpression, " \t\n\r\0\x0B.*").strip != ""
                && !this.isCommaToken(myExpression)) {
                $tables[] = (myExpression, " \t\n\r\0\x0B.*").strip;
            }
        }

        if ($tables.isEmpty &&  $tokens.isSet("USING")) {
            foreach (myTable; $tokens["FROM"] ) {
                $tables[] = (myTable["table"], " \t\n\r\0\x0B.*").strip;
            }
            $tokens["FROM"] = $tokens["USING"];
            unset($tokens["USING"]);
        }

        $options = [];
        if ($tokens.isSet("OPTIONS")) {
            $options = $tokens["OPTIONS"];
            $tokens.unSet("OPTIONS");
        }

        $tokens["DELETE"] = ["options" : ($options.isEmpty ? false : $options),
                                  "tables" : ($tables.isEmpty ? false : $tables)];
        return $tokens;
    }
}
