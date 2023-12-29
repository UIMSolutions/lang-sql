module langs.sql.sqlparsers.processors.set;

import lang.sql;

@safe:

// Processes the SET statements.
class SetProcessor : Processor {

    protected Json processExpressionList(tokens) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process(tokens);
    }

    /**
     * A SET list is simply a list of key = value expressions separated by comma (,).
     * This auto produces a list of the key/value expressions.
     */
    protected Json processAssignment(baseExpression) {
        auto myAssignment = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));

        // TODO: if the left side of the assignment is a reserved keyword, it should be changed to colref

        Json newExpression = createExpression("EXPRESSION", baseExpression.strip);
        newExpression["sub_tree"] ~= myAssignment.isEmpty ? false : myAssignment;
        return newExpression; 
    }

    Json process(string[] tokens, bool isUpdate = false) {
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
                auto myAssignment = this.processAssignment(baseExpression);
                if (!isUpdate && isVarType != false) {
                    Json assignItem = Json.emptyObject;
                    assignItem["expr_type"] = isVarType;
                    myAssignment["sub_tree"] ~= Json.emptyArray;
                    myAssignment["sub_tree"] ~= assignItem;
                }
                result = myAssignment;
                baseExpression = "";
                isVarType = false;
                continue 2;

            default:
            }
            baseExpression ~= myToken;
        }

        if (baseExpression.strip != "") {
            auto myAssignment = this.processAssignment(baseExpression);
            if (!isUpdate && isVarType != false) {
                myAssignment["sub_tree"][0]["expr_type"] = isVarType;
            }
            myresult ~= myAssignment;
        }

        return myresult;
    }

}
