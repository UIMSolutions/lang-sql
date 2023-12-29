module langs.sql.sqlparsers.processors.delete_;
import langs.sql;

@safe:
// Processes the DELETE statement parts and splits multi-table deletes.
class DeleteProcessor : Processor {

    Json process(Json someTokens) {
        mytables = [];
        Json myDelete = someTokens["DELETE"];

        foreach (myExpression; myDelete) {
            if (myExpression.toUpper != "DELETE" && (myExpression, " \t\n\r\0\x0B.*").strip != ""
                && !this.isCommaToken(myExpression)) {
                mytables ~= (myExpression, " \t\n\r\0\x0B.*").strip;
            }
        }

        if (mytables.isEmpty &&  mytokens.isSet("USING")) {
            mytokens["FROM"].each!(token => mytables ~= (myTable["table"], " \t\n\r\0\x0B.*").strip);
            mytokens["FROM"] = mytokens["USING"];
            mytokens.remove("USING");
        }

        auto myoptions = [];
        if (mytokens.isSet("OPTIONS")) {
            myoptions = mytokens["OPTIONS"];
            mytokens.unSet("OPTIONS");
        }

        mytokens["DELETE"] = ["options" : (myoptions.isEmpty ? false : myoptions), "tables" : (mytables.isEmpty ? false : mytables)];
        return mytokens;
    }
}
