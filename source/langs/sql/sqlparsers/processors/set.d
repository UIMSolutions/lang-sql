module langs.sql.sqlparsers.processors.set;

import lang.sql;

@safe:

/**
 * This file : the processor for the SET statements.
 * This class processes the SET statements.
 * */
class SetProcessor : AbstractProcessor {

    protected auto processExpressionList($tokens) {
        auto myProcessor = new ExpressionListProcessor(this.options);
        return myProcessor.process($tokens);
    }

    /**
     * A SET list is simply a list of key = value expressions separated by comma (,).
     * This auto produces a list of the key/value expressions.
     */
    protected auto processAssignment(baseExpression) {
        isAssignment = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));

        // TODO: if the left side of the assignment is a reserved keyword, it should be changed to colref

        return ["expr_type" : expressionType(EXPRESSION, "base_expr" : baseExpression.strip,
                     "sub_tree" : (empty(isAssignment) ? false : isAssignment));
    }

    auto process($tokens, bool isUpdate = false) {
        $result = [];
        string baseExpression = "";
        bool isAssignment = false;
        bool isVarType = false;

        foreach (myToken; $tokens) {
            auto strippedToken = myToken.strip;
            auto upperToken = strippedToken.toUpper;

            switch (upperToken) {
            case 'LOCAL':
            case 'SESSION':
            case 'GLOBAL':
                if (!isUpdate) {
                    $result[] = ["expr_type" : expressionType("RESERVED"), "base_expr" : strippedToken);
                    isVarType = this.getVariableType("@@" ~ upperToken ~ ".");
                    baseExpression = "";
                    continue 2;
                }
                break;

            case ",":
                isAssignment = this.processAssignment(baseExpression);
                if (!isUpdate && isVarType != false) {
                    isAssignment["sub_tree"][0]["expr_type"] = isVarType;
                }
                $result[] = isAssignment;
                baseExpression = "";
                isVarType = false;
                continue 2;

            default:
            }
            baseExpression ~= myToken;
        }

        if (baseExpression.strip != "") {
            isAssignment = this.processAssignment(baseExpression);
            if (!isUpdate && isVarType != false) {
                isAssignment["sub_tree"][0]["expr_type"] = isVarType;
            }
            $result[] = isAssignment;
        }

        return $result;
    }

}