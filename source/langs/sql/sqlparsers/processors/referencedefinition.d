module langs.sql.sqlparsers.processors.referencedefinition;

import lang.sql;

@safe:

/**
 * This class processes the reference definition part of the CREATE TABLE statements.
*/
class ReferenceDefinitionProcessor : AbstractProcessor {

    protected string buildReferenceDef(myExpression, baseExpression, myKey) {
        myExpression["till"] = myKey;
        myExpression.baseExpression = baseExpression;
        return myExpression;
    }

    auto process($tokens) {

        myExpression = ["expr_type" : expressionType("REFERENCE"), "base_expr" : false, "sub_tree" : []];
        baseExpression = "";

        foreach (myKey : myToken; $tokens) {

            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;

            switch (upperToken) {

            case ",":
            // we stop on a single comma
            //  or at the end of the array $tokens
                myExpression = this.buildReferenceDef(myExpression, substr(baseExpression, 0, -myToken.length).strip, myKey - 1);
                break 2;

            case "REFERENCES":
                myExpression["sub_tree"][] = createExpression("RESERVED", strippedToken];
                currentCategory = upperToken;
                break;

            case "MATCH":
                if (currentCategory == "REF_COL_LIST") {
                    myExpression["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    currentCategory = "REF_MATCH";
                    continue 2;
                }
                # else?
                break;

            case "FULL":
            case "PARTIAL":
            case "SIMPLE":
                if (currentCategory == "REF_MATCH") {
                    myExpression["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression["match"] = upperToken;
                    currentCategory = "REF_COL_LIST";
                    continue 2;
                }
                # else?
                break;

            case "ON":
                if (currentCategory == "REF_COL_LIST") {
                    myExpression["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    currentCategory = "REF_ACTION";
                    continue 2;
                }
                # else ?
                break;

            case "UPDATE":
            case "DELETE":
                if (currentCategory == "REF_ACTION") {
                    myExpression["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    currentCategory = "REF_OPTION_" . upperToken;
                    continue 2;
                }
                # else ?
                break;

            case "RESTRICT":
            case "CASCADE":
                if (strpos(currentCategory, "REF_OPTION_") == 0) {
                    myExpression["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression["on_"  ~ strtolower(substr(currentCategory, -6))] = upperToken;
                    continue 2;
                }
                # else ?
                break;

            case "SET":
            case "NO":
                if (strpos(currentCategory, "REF_OPTION_") == 0) {
                    myExpression["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression["on_" ~ substr(currentCategory, -6).toLower] = upperToken;
                    currentCategory = "SEC_" . currentCategory;
                    continue 2;
                }
                # else ?
                break;

            case "NULL":
            case "ACTION":
                if (strpos(currentCategory, "SEC_REF_OPTION_") == 0) {
                    myExpression["sub_tree"][] = ["expr_type" : expressionType("RESERVED"), "base_expr": strippedToken];
                    myExpression["on_" ~ substr(currentCategory, -6).toLower] ~= " " ~ upperToken;
                    currentCategory = "REF_COL_LIST";
                    continue 2;
                }
                # else ?
                break;

            default:
                switch (currentCategory) {

                case "REFERENCES":
                    if (upperToken[0] == "(" && substr(upperToken, -1) == ")") {
                        // index_col_name list
                        auto myProcessor = new IndexColumnListProcessor(this.options);
                        $cols = $processor.process(this.removeParenthesisFromStart(strippedToken));
                        myExpression["sub_tree"][] = [
                            "expr_type" : expressionType("COLUMN_LIST"), 
                            "base_expr" : strippedToken,
                            "sub_tree" : $cols];
                        currentCategory = "REF_COL_LIST";
                        continue 3;
                    }
                    // foreign key reference table name
                    myExpression["sub_tree"][] = [
                        "expr_type" : expressionType("TABLE"), 
                        "table" : strippedToken,
                        "base_expr" : strippedToken, 
                        "no_quotes" : this.revokeQuotation(strippedToken)];
                    continue 3;

                default:
                # else ?
                    break;
                }
                break;
            }
        }

        if (!myExpression.isSet("till")) {
            myExpression = this.buildReferenceDef(myExpression, baseExpression.strip, -1);
        }
        return myExpression;
    }
}