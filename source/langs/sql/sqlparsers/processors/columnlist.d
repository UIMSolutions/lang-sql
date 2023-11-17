module langs.sql.sqlparsers.processors.columnlist;

import lang.sql;

@safe:

/**
 * This file : the processor for column lists like in INSERT statements.
 * This class processes column-lists.
 */
class ColumnListProcessor : AbstractProcessor {
    auto process($tokens) {
        $columns = explode(",", $tokens);
        auto myCols = [];
        foreach (myKey, myValue; $columns) {
            myCols = ["expr_type" : expressionType(COLREF, "base_expr" : trim(myValue),
                            "no_quotes" : this.revokeQuotation(myValue));
        }
        return myCols;
    }
}