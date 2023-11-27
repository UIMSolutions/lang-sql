module langs.sql.sqlparsers.processors.columnlist;

import lang.sql;

@safe:

// This class processes column-lists.
class ColumnListProcessor : AbstractProcessor {
  auto process(string stringWithTokens) {
    string[] tokenNames = stringWithTokens.split(",");
    auto myColumns = [];
    foreach (myKey, myTokenName; tokenNames) {
      myColumns = [
        "expr_type": expressionType("COLREF"),
        "base_expr": myTokenName.strip,
        "no_quotes": this.revokeQuotation(myTokenName)
      ];
    }
    return myColumns;
  }
}
