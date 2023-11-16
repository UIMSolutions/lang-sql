
/**
 * SetProcessor.php
 *
 * This file : the processor for the SET statements.
 */

module langs.sql.PHPSQLParser.processors.set;

import lang.sql;

@safe:

/**
 *
 * This class processes the SET statements.
 *
 * @author arothe
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
    protected auto processAssignment($base_expr) {
        $assignment = this.processExpressionList(this.splitSQLIntoTokens($base_expr));

        // TODO: if the left side of the assignment is a reserved keyword, it should be changed to colref

        return ["expr_type" :  expressionType(EXPRESSION, "base_expr" :  trim($base_expr),
                     "sub_tree" :  (empty($assignment) ? false : $assignment));
    }

    auto process($tokens, $isUpdate = false) {
        $result = [];
        $baseExpr = "";
        $assignment = false;
        $varType = false;

        foreach ($token; $tokens) {
            $trim = $token.strip;
            $upper = $trim.toUpper;

            switch ($upper) {
            case 'LOCAL':
            case 'SESSION':
            case 'GLOBAL':
                if (!$isUpdate) {
                    $result[] = ["expr_type" :  expressionType(RESERVED, "base_expr" :  $trim);
                    $varType = this.getVariableType("@@" . $upper . ".");
                    $baseExpr = "";
                    continue 2;
                }
                break;

            case ',':
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
            $baseExpr  ~= $token;
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