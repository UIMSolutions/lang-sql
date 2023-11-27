module langs.sql.sqlparsers.processors.insert;

import lang.sql;

@safe:

// This class processes the INSERT statements.
class InsertProcessor : AbstractProcessor {

    protected auto processOptions($tokenList) {
        if (!$tokenList.isSet("OPTIONS")) {
            return [];
        }
        }
        $result = [];
        foreach ($tokenList["OPTIONS"] as $token) {
            $result[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : $token.strip);
        }
        return $result;
    }

    protected auto processKeyword(myKeyword, $tokenList) {
        if (!$tokenList.isSet(myKeyword)) {
            return ["", false, []);
        }

        string myTable = "";
        $cols = false;
        $result = [];

        foreach ($token; $tokenList[myKeyword]) {
            auto strippedToken = myToken.strip;

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {
            case "INTO":
                $result[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                break;

            case "INSERT":
            case "REPLACE":
                break;

            default:
                if (myTable.isEmpty) {
                    myTable = strippedToken;
                    break;
                }

                if ($cols == false) {
                    $cols = strippedToken;
                }
                break;
            }
        }
        return [myTable, $cols, $result);
    }

    protected auto processColumns($cols) {
        if ($cols == false) {
            return $cols;
        }
        if ($cols[0] == "(" && substr($cols, -1) == ")") {
            $parsed = ["expr_type" : expressionType("BRACKET_EXPRESSION"), "base_expr" : $cols,
                            "sub_tree" : false];
        }
        $cols = this.removeParenthesisFromStart($cols);
        if (stripos($cols, "SELECT") == 0) {
            auto myProcessor = new DefaultProcessor(this.options);
            $parsed["sub_tree"] = [
                    ["expr_type" : expressionType("QUERY"), "base_expr" : $cols,
                            "sub_tree" : $processor.process($cols)));
        } else {
            auto myProcessor = new ColumnListProcessor(this.options);
            $parsed["sub_tree"] = $processor.process($cols);
            $parsed["expr_type"] .isExpressionType("COLUMN_LIST");
        }
        return $parsed;
    }

    auto process($tokenList, $token_category = "INSERT") {
        string myTable = "";
        $cols = false;
        $comments = [];

        foreach (myKey : &$token; $tokenList) {
            if (myKey == "VALUES") {
                continue;
            }
            foreach (&$value; $token as ) {
                if (this.isCommentToken($value)) {
                     $comments[] = super.processComment($value);
                     $value = "";
                }
            }
        }

        $parsed = this.processOptions($tokenList);
        unset($tokenList["OPTIONS"]);

        list(myTable, $cols, myKey) = this.processKeyword("INTO", $tokenList);
        $parsed = array_merge($parsed, myKey);
        unset($tokenList["INTO"]);

        if (myTable.isEmpty && in_array($token_category, ["INSERT", "REPLACE"))) {
            list(myTable, $cols, myKey) = this.processKeyword($token_category, $tokenList);
        }

        $parsed[] = ["expr_type" : expressionType(TABLE, "table" : myTable,
                          "no_quotes" : this.revokeQuotation(myTable), "alias" : false, "base_expr" : myTable);

        $cols = this.processColumns($cols);
        if ($cols != false) {
            $parsed[] = $cols;
        }

        $parsed = array_merge($parsed, $comments);

        $tokenList[$token_category] = $parsed;
        return $tokenList;
    }
}
