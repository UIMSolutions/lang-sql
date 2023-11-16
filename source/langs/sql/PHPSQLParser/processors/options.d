module langs.sql.PHPSQLParser.processors.options;

import lang.sql;

@safe:

// This file : the processor for the statement options.
// This class processes the statement options.
class OptionsProcessor : AbstractProcessor {

    auto process($tokens) {
        $resultList = [];

        foreach (myToken; $tokens) {

            $tokenList = this.splitSQLIntoTokens(myToken);
            $result = [];

            foreach (myReserved; $tokenList) {
                auto strippedToken = myReserved.strip;
                if (strippedToken.isEmpty) {
                    continue;
                }
                $result[] = ["expr_type" : expressionType(RESERVED, "base_expr" : strippedToken);
            }
            $resultList[] = ["expr_type" : expressionType(EXPRESSION, "base_expr" : myToken.strip,
                                  "sub_tree" : $result];
        }

        return $resultList;
    }
}

