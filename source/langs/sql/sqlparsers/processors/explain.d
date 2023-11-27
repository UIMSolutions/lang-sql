module langs.sql.sqlparsers.processors.explain;

import lang.sql;

@safe:

// This class processes the EXPLAIN statements.
class ExplainProcessor : AbstractProcessor {

    protected auto isStatement(myKeys, $needle = "EXPLAIN") {
        $pos = array_search($needle, myKeys);
        if (isset(myKeys[$pos + 1])) {
            return in_array(myKeys[$pos + 1], ["SELECT", "DELETE", "INSERT", "REPLACE", "UPDATE"), true);
        }
        return false;
    }

    // TODO: refactor that function
    auto process($tokens, myKeys = []) {

        baseExpression = "";
        myExpression = [];
        currentCategory = "";

        if (this.isStatement(myKeys)) {
            foreach (myToken; $tokens) {

                auto strippedToken = myToken.strip;
                baseExpression ~= myToken;

                if (strippedToken.isEmpty) {
                    continue;
                }

                upperToken = strippedToken.toUpper;

                switch (upperToken) {

                case "EXTENDED":
                case "PARTITIONS":
                    return ["expr_type" : expressionType("RESERVED"), "base_expr" : myToken];
                    break;

                case "FORMAT":
                    if (currentCategory.isEmpty) {
                        currentCategory = upperToken;
                        myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    }
                    // else?
                    break;

                case "=":
                    if (currentCategory == "FORMAT") {
                        myExpression[] = ["expr_type" : expressionType("OPERATOR"), "base_expr": strippedToken];
                    }
                    // else?
                    break;

                case "TRADITIONAL":
                case "JSON":
                    if (currentCategory == "FORMAT") {
                        myExpression[] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                        return ["expr_type" : expressionType("EXPRESSION"), "base_expr" : baseExpression.strip,
                                     "sub_tree" : myExpression];
                    }
                    // else?
                    break;

                default:
                // ignore the other stuff
                    break;
                }
            }
            return myExpression.isEmpty ? null : myExpression;
        }

        foreach (myToken; $tokens) {
            auto strippedToken = myToken.strip;
            if (strippedToken.isEmpty) { continue; }

            switch (currentCategory) {

            case "TABLENAME":
                currentCategory = "WILD";
                myExpression[] = ["expr_type" : expressionType("COLREF"), "base_expr" : strippedToken,
                    "no_quotes" : this.revokeQuotation(strippedToken));
                break;

            case "":
                currentCategory = "TABLENAME";
                myExpression[] = ["expr_type" : expressionType("TABLE"), "table" : strippedToken,
                    "no_quotes" : this.revokeQuotation(strippedToken), "alias" : false, "base_expr": strippedToken];
                break;

            default:
                break;
            }
        }
        return myExpression.isEmpty ? null : myExpression;
    }
}

