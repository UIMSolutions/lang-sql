module langs.sql.sqlparsers.processors.set;

import lang.sql;

@safe:

// Processes the SET statements.
class SetProcessor : AbstractProcessor {

    protected auto processExpressionList(tokens) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process(tokens);
    }

    /**
     * A SET list is simply a list of key = value expressions separated by comma (,).
     * This auto produces a list of the key/value expressions.
     */
    protected auto processAssignment(baseExpression) {
        anAssignment = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));

        // TODO: if the left side of the assignment is a reserved keyword, it should be changed to colref

        return createExpression("EXPRESSION"), "base_expr" : baseExpression.strip,
        "sub_tree" : (empty(anAssignment) ? false : anAssignment)];
    }

    auto process(string[] tokens, bool isUpdate = false) {
        Json result;
        string baseExpression = "";
        bool anAssignment = false;
        bool isVarType = false;

        foreach (myToken; tokens) {
            auto strippedToken = myToken.strip;
            auto upperToken = strippedToken.toUpper;

            switch (upperToken) {
            case "LOCAL":
            case "SESSION":
            case "GLOBAL":
                if (!isUpdate) {
                    result = createExpression("RESERVED", strippedToken);
                    isVarType = this.getVariableType("@@" ~ upperToken ~ ".");
                    baseExpression = "";
                    continue 2;
                }
                break;

            case ",":
                auto anAssignment = this.processAssignment(baseExpression);
                if (!isUpdate && isVarType != false) {
                    Json assignItem = Json.emptyObject;
                    assignItem["expr_type"] = isVarType;
                    anAssignment["sub_tree"] = Json.emptyArray;
                    anAssignment["sub_tree"] ~= assignItem;
                }
                result = anAssignment;
                baseExpression = "";
                isVarType = false;
                continue 2;

            default:
            }
            baseExpression ~= myToken;
        }

        if (baseExpression.strip != "") {
            anAssignment = this.processAssignment(baseExpression);
            if (!isUpdate && isVarType != false) {
                anAssignment["sub_tree"][0]["expr_type"] = isVarType;
            }
             myresult[] = anAssignment;
        }

        return  myresult;
    }

}
