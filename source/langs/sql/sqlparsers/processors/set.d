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
        $assignment = this.processExpressionList(this.splitSQLIntoTokens(baseExpression));

        // TODO: if the left side of the assignment is a reserved keyword, it should be changed to colref

        return ["expr_type" : expressionType(EXPRESSION, "base_expr" : baseExpression.strip,
                     "sub_tree" : (empty($assignment) ? false : $assignment));
    }

    auto process($tokens, $isUpdate = false) {
        $result = [];
        $baseExpr = "";
        $assignment = false;
        $varType = false;

        foreach ($token; $tokens) {
            auto strippedToken = $token.strip;
            upperToken = strippedToken.toUpper;

            switch (upperToken) {
            case 'LOCAL':
            case 'SESSION':
            case 'GLOBAL':
                if (!$isUpdate) {
                    $result[] = ["expr_type" : expressionType(RESERVED, "base_expr" : strippedToken);
                    $varType = this.getVariableType("@@" . upperToken . ".");
                    $baseExpr = "";
                    continue 2;
                }
                break;

            case ",":
                $assignment = this.processAssignment($baseExpr);
                if (!$isUpdate && $varType != false) {
                    $assignment["sub_tree"][0]["expr_type"] = $varType;
                }
                $result[] = $assignment;
                $baseExpr = "";
                $varType = false;
                continue 2;

            default:
            }
            $baseExpr ~= $token;
        }

        if (trim($baseExpr) != "") {
            $assignment = this.processAssignment($baseExpr);
            if (!$isUpdate && $varType != false) {
                $assignment["sub_tree"][0]["expr_type"] = $varType;
            }
            $result[] = $assignment;
        }

        return $result;
    }

}