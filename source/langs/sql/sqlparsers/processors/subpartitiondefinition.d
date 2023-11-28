module langs.sql.sqlparsers.processors.subpartitiondefinition;

import lang.sql;

@safe:

// This class processes the SUBPARTITION statements within CREATE TABLE. */
class SubpartitionDefinitionProcessor : AbstractProcessor {

    protected Json getReservedType(myToken) {
      Json result = Json.emptyObject;
      result["expr_type"] = expressionType("RESERVED");
      result["base_expr"] = myToken;
      return result;
    }

    protected Json getConstantType(myToken) {
        return createExpression("CONSTANT"), "base_expr" : myToken];
    }

    protected Json getOperatorType(myToken) {
        return createExpression("OPERATOR"), "base_expr" : myToken];
    }

    protected Json getBracketExpressionType(myToken) {
        return createExpression("BRACKET_EXPRESSION"), "base_expr" : myToken, "sub_tree" : false];
    }

    auto process($tokens) {

        auto $result = [];
        string previousCategory = "";
        string currentCategory = "";
        Json parsedSQL = [];
        auto myExpression = [];
        string baseExpression = "";
        auto $skip = 0;

        foreach (myTokenKey, myToken; $tokens) {
            auto strippedToken = myToken.strip;
            baseExpression ~= myToken;

            if ($skip > 0) {
                $skip--;
                continue;
            }

            if ($skip < 0) {
                break;
            }

            if (strippedToken.isEmpty) {
                continue;
            }

            upperToken = strippedToken.toUpper;
            switch (upperToken) {

            case "SUBPARTITION":
                if (currentCategory.isEmpty) {
                    myExpression[] = this.getReservedType(strippedToken);
                    $parsed = createExpression("SUBPARTITION_DEF"), "base_expr" : baseExpression.strip,
                                    "sub_tree" : false];
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "COMMENT":
                if (previousCategory == "SUBPARTITION") {
                    myExpression[] = createExpression("SUBPARTITION_COMMENT"), "base_expr" : false,
                                    "sub_tree" : false, "storage" : substr(baseExpression, 0, -myToken.length)];

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = myToken;
                    myExpression = [this.getReservedType(strippedToken)];

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "STORAGE":
                if (previousCategory == "SUBPARTITION") {
                    // followed by ENGINE
                    myExpression[] = createExpression("ENGINE"), "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -myToken.length)];

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = myToken;
                    myExpression = [this.getReservedType(strippedToken)];

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "ENGINE":
                if (currentCategory == "STORAGE") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = upperToken;
                    continue 2;
                }
                if (previousCategory == "SUBPARTITION") {
                    myExpression[] = createExpression("ENGINE"), "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -myToken.length)];

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = myToken;
                    myExpression = [this.getReservedType(strippedToken)];
                    
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "=":
                if (in_array(currentCategory, ["ENGINE", "COMMENT", "DIRECTORY", "MAX_ROWS", "MIN_ROWS"])) {
                    myExpression[] = this.getOperatorType(strippedToken);
                    continue 2;
                }
                // else ?
                break;

            case ",":
                if (previousCategory == "SUBPARTITION" && currentCategory.isEmpty) {
                    // it separates the subpartition-definitions
                    $result[] = $parsed;
                    $parsed = [];
                    baseExpression = "";
                    myExpression = [];
                }
                break;

            case "DATA":
            case "INDEX":
                if (previousCategory == "SUBPARTITION") {
                    // followed by DIRECTORY
                    myExpression[] = ["expr_type" : constant("SqlParser\utils\expressionType(SUBPARTITION_" ~ upperToken ~ "_DIR"),
                                    "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -myToken.length)];

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = myToken;
                    myExpression = [this.getReservedType(strippedToken)];

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "DIRECTORY":
                if (currentCategory == "DATA" || currentCategory == "INDEX") {
                    myExpression[] = this.getReservedType(strippedToken);
                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            case "MAX_ROWS":
            case "MIN_ROWS":
                if (previousCategory == "SUBPARTITION") {
                    myExpression[] = ["expr_type" : constant("SqlParser\utils\expressionType(SUBPARTITION_" . upperToken),
                                    "base_expr" : false, "sub_tree" : false,
                                    "storage" : substr(baseExpression, 0, -myToken.length)];

                    $parsed["sub_tree"] = myExpression;
                    baseExpression = myToken;
                    myExpression = [this.getReservedType(strippedToken)];

                    currentCategory = upperToken;
                    continue 2;
                }
                // else ?
                break;

            default:
                processByCategory();
                break;
            }

            previousCategory = currentCategory;
            currentCategory = "";
        }

        $result[] = $parsed;
        return $result;
    }

    auto processByCategory(string aCategory) {
        switch (aCategory) {

                case "MIN_ROWS":
                case "MAX_ROWS":
                case "ENGINE":
                case "DIRECTORY":
                case "COMMENT":
                    myExpression[] = this.getConstantType(strippedToken);

                    $last = array_pop($parsed["sub_tree"]);
                    $last["sub_tree"] = myExpression;
                    $last.baseExpression = baseExpression.strip;
                    baseExpression = $last["storage"] ~ baseExpression;
                    unset($last["storage"]);

                    $parsed["sub_tree"][] = $last;
                    $parsed.baseExpression = baseExpression.strip;
                    myExpression = $parsed["sub_tree"];
                    unset($last);

                    currentCategory = previousCategory;
                    break;

                case "SUBPARTITION":
                // that is the subpartition name
                    $last = array_pop(myExpression);
                    $last["name"] = strippedToken;
                    myExpression[] = $last;
                    myExpression[] = this.getConstantType(strippedToken);
                    $parsed["sub_tree"] = myExpression;
                    $parsed.baseExpression = baseExpression.strip;
                    break;

                default:
                    break;
                }
    }
}
