module langs.sql.sqlparsers.processors.options;

import lang.sql;

@safe:

// This file : the processor for the statement options.
// This class processes the statement options.
class OptionsProcessor : AbstractProcessor {

  auto process( mytokens) {
     myresultList = [];

    foreach (myToken;  mytokens) {

       mytokenList = this.splitSQLIntoTokens(myToken);
       myresult = [];

      foreach (myReserved;  mytokenList) {
        auto strippedToken = myReserved.strip;
        if (strippedToken.isEmpty) {
          continue;
        }

         myresult ~= ["expr_type": expressionType("RESERVED"), "base_expr": strippedToken];
      }
       myresultList ~= ["expr_type": expressionType("EXPRESSION"), "base_expr": myToken.strip, "sub_tree":  myresult];
    }

    return  myresultList;
  }
}
