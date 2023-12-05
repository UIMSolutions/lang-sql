module langs.sql.sqlparsers.processors.delete_;
import lang.sql;

@safe:
// Processes the DELETE statement parts and splits multi-table deletes.
class DeleteProcessor : AbstractProcessor {

    auto process(mytokens) {
        mytables = [];
        mydel = mytokens["DELETE"];

        foreach (myExpression; mytokens["DELETE"]) {
            if (myExpression.toUpper != "DELETE" && (myExpression, " \t\n\r\0\x0B.*").strip != ""
                && !this.isCommaToken(myExpression)) {
                mytables ~= (myExpression, " \t\n\r\0\x0B.*").strip;
            }
        }

        if (mytables.isEmpty &&  mytokens.isSet("USING")) {
            foreach (myTable; mytokens["FROM"] ) {
                mytables ~= (myTable["table"], " \t\n\r\0\x0B.*").strip;
            }
            mytokens["FROM"] = mytokens["USING"];
            unset(mytokens["USING"]);
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
